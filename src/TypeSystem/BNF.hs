 {-# LANGUAGE FlexibleInstances #-}
 {-# LANGUAGE MultiParamTypeClasses #-}
module TypeSystem.BNF where

{-
This module defines BNF-expressions and rules
-}

import Utils.Utils
import Utils.ToString

import TypeSystem.Types

import Text.Parsec
import TypeSystem.Parser.ParsingUtils

import Data.Maybe
import Data.Either

import Lens.Micro hiding ((&))
import Control.Arrow ((&&&))

{- Syntax is described in a Backus-Naur format, a simple naive parser is constructed from it. -}


data BNF 	= Literal String	-- Literally parse 'String'
		| BNFRuleCall Name	-- Parse the rule with the given name
		| BNFSeq [BNF]		-- Sequence of parts
		| Identifier
		| Any
		| LineChar
		| Lower
		| Upper
		| Digit
		| Hex
		| String
		| Number
	deriving (Show, Eq, Ord)




wsModeInfo
      = [ (IgnoreWS, "Totally ignore whitespace")
	, (StrictWS, "Parse whitespace for this rule only")
	, (StrictWSRecursive, "Parse whitespace for this rule and all recursively called rules")
	] |> over _1 (toParsable &&& id)

-- Also update: matchTyping in the expressionParser; TargetLanguageParser
-- ((BNF-Name; BNF-representation; targetLang-parser (is wrapped in a MLiteral afterwards); check that something is valid) (documentation, documentation regex)
builtinSyntax	= 
	[ (("Identifier", Identifier, identifier), 
		("Matches an identifier", "[a-z][a-zA-Z0-9]*"))
	, (("Number", Number, number |> show), 
		("Matches an (negative) integer. Integers parsed by this might be passed into the builtin arithmetic functions.", "-?[0-9]*"))
	, (("Any", Any, anyChar |> (:[])),
		 ("Matches a single character, whatever it is, including newline characters", "."))
	, (("Lower", Lower, oneOf lowers |> (:[])), 
		("Matches a lowercase letter", "[a-z]"))
	, (("Upper", Upper, oneOf uppers |> (:[])),
		("Matches an uppercase letter", "[A-Z]"))
	, (("Digit", Digit, oneOf digits |> (:[])),
		("Matches an digit", "[0-9]"))
	, (("Hex", Hex, oneOf hex |> (:[]))
		, ("Matches a hexadecimal digit", "[0-9a-fA-F]"))
	, (("String", String, dqString'),
		("Matches a double quote delimted string, returns the value including the double quotes", "\"([^\"\\]|\\\"|\\\\)*\""))
	, (("LineChar", LineChar, noneOf "\n" |> (:[])),
		("Matches a single character that is not a newline", "[^\\n]"))
	]

isValidBuiltin	:: BNF -> String -> Bool
isValidBuiltin bnf s
	= let	result	= runParserT (getParserForBuiltin bnf) () ("Pattern "++show s++" against bnf "++show bnf) s
		in
		result |> isRight & either (const False) id

isBuiltin	:: BNF -> Bool
isBuiltin bnf	= bnf `elem` (builtinSyntax |> fst |> snd3)



getParserForBuiltin	:: BNF -> Parser u String
getParserForBuiltin bnf
	= builtinSyntax |> fst |> dropFst3 & lookup bnf & fromMaybe (error $ "No builtin for parser defined for "++show bnf++", this is a bug")



normalize	:: BNF -> BNF
normalize (BNFSeq seq)
	= let	seq'	= (seq |> normalize) >>= (\bnf -> fromMaybe [bnf] $ fromSeq bnf) in
		case seq' of
			[bnf] 	-> bnf
			_	-> BNFSeq seq'
normalize bnf	= bnf

data WSMode	= IgnoreWS | StrictWS | StrictWSRecursive
	deriving (Show, Eq)




fromSingle	:: BNF -> Maybe BNF
fromSingle (BNFSeq [bnf])	= Just bnf
fromSingle (BNFSeq _)		= Nothing
fromSingle bnf			= Just bnf


fromRuleCall	:: BNF -> Maybe Name
fromRuleCall (BNFRuleCall nm)	= Just nm
fromRuleCall _			= Nothing

isRuleCall	:: BNF -> Bool
isRuleCall BNFRuleCall{}	= True
isRuleCall _			= False

isSeq		:: BNF -> Bool
isSeq BNFSeq{}	= True
isSeq _		= False

fromSeq		:: BNF -> Maybe [BNF]
fromSeq (BNFSeq seq)	= Just seq
fromSeq _	= Nothing

fromSeq'	:: BNF -> [BNF]
fromSeq' (BNFSeq seq)	= seq
fromSeq' bnf	= [bnf]

calledRules	:: BNF -> [TypeName]
calledRules (BNFRuleCall nm)	= [nm]
calledRules (BNFSeq bnfs)	= bnfs >>= calledRules
calledRules _			= []

containsRule	:: TypeName ->  BNF -> Bool
containsRule tn bnf
		= tn `elem` calledRules bnf


-- First call, without consumption of a character
firstCall	:: BNF -> Maybe TypeName
firstCall (BNFRuleCall nm)	= Just nm
firstCall (BNFSeq (ast:_))	= firstCall ast
firstCall _			= Nothing








enterRule	:: WSMode -> WSMode
enterRule StrictWS	= IgnoreWS
enterRule wsMode	= wsMode


strictest		:: WSMode -> WSMode -> WSMode
strictest StrictWSRecursive _	= StrictWSRecursive
strictest StrictWS IgnoreWS	= StrictWS
strictest IgnoreWS IgnoreWS	= IgnoreWS
strictest a b			= strictest b a


instance ToString BNF where
	toParsable	= toStr toParsable
	toCoParsable	= toParsable

	debug (BNFSeq asts)
			= asts |> toStr debug & unwords & inParens
	debug ast	= toStr debug ast

toStr			:: (BNF -> String) -> BNF -> String
toStr _ (Literal str)	= show str
toStr f (BNFSeq asts)	= asts |> f & unwords
toStr _ (BNFRuleCall n)	= n
toStr _ builtin		= builtinSyntax |> fst |> dropTrd3 |> swap & lookup builtin
				& fromMaybe (error $ "BUG: you added a new syntactic form "++show builtin++" which you didn't add to the builtinSytnax yet")

instance ToString WSMode where
	toParsable IgnoreWS	= "::="
	toParsable StrictWS	= "~~="
	toParsable StrictWSRecursive	= "//="


instance ToString (Name, Int, WSMode, Bool, String, [BNF]) where
	toParsable (n, i, ws, group, extra, bnfs)
		= padR i ' ' n ++ toParsable ws ++ _showGroup group ++ " " ++ extra ++ 
			if null bnfs then "< no bnfs declared >"
				else toParsable' ("\n" ++ replicate i ' ' ++  "| ") bnfs

_showGroup True	= " $"
_showGroup False= ""

instance Refactorable TypeName BNF where
	refactor ftn (BNFRuleCall nm)	= BNFRuleCall $ ftn nm
	refactor ftn (BNFSeq seq)	= seq |> refactor ftn & BNFSeq
	refactor _   bnf		= bnf




