	module Changer.ChangesParser where

{-
Yeah, what would this module implement?
-}
import TypeSystem
import Changer.Changes
import Utils.Utils
import Utils.ToString
import TypeSystem.Parser.ParsingUtils
import TypeSystem.Parser.BNFParser
import TypeSystem.Parser.FunctionParser
import TypeSystem.Parser.TypeSystemParser
import TypeSystem.Parser.RuleParser

import Data.Maybe
import Data.Map (Map)
import qualified Data.Map as M

import Control.Arrow ((&&&))
import Control.Monad
import Control.Monad.Trans
import qualified Data.Bifunctor as BF

import Text.Parsec

import Lens.Micro hiding ((&))


-- The simple, key only case
defaultChange	:: Parser u k -> Parser u (DefaultChange k v)
defaultChange pa
	= try	(do	string "Delete"
			a	<- inWs pa
			return $ Delete a)
	  <|> try (do	string "Copy"
			a0	<- inWs pa
			string "as" <|> string "to"
			a1	<- inWs pa
			return $ Copy a0 a1)
	  <|> try (do	string "Rename"
			a0	<- inWs pa
			string "to" <|> string "as"
			a1	<- inWs pa
			return $ Rename a0 a1)


-- The more complicated case
defaultChange'	:: Parser u k -> Parser u (DefaultChange k v) -> Parser u (DefaultChange k v)
defaultChange' pk pEdit
	= try (defaultChange pk) <|> pEdit

defaultChanges	:: Parser u k -> Parser u (DefaultChange k v) -> Parser u [DefaultChange k v]
defaultChanges pk pEdit
	= many $ try (nls *> ws *> defaultChange' pk pEdit <* ws )


change'		:: Parser u k -> Parser u b -> Parser u (Either (DefaultChange k v) b)
change' pa pb	= try (pb |> Right) <|> (defaultChange pa |> Left)


changes' pa pb	= many $ try (nls *> ws *> change' pa pb <* ws)


syntaxChange	:: Parser u (DefaultChange TypeName ([BNF], WSMode, Bool))
syntaxChange   = (do	name	<- inWs identifier
			wsMode	<- inWs parseWSMode
			doGroup	<- (inWs (char '$') >> return True) <|> return False
			string "..."
			inWs $ string "|"
			bnfs	<- inWs bnfLine
			return $ Edit name (bnfs, wsMode, doGroup))
		 <|> (try parseBnfRule |> uncurry Override) 



functionChange	:: Map Name Type -> Syntax -> Parser u (DefaultChange Name Function)
functionChange types syntax
	= do	(nm, tps)	<- metaSignature syntax
		nls1
		cons		<- try (string "..." >> nls1 >> return Edit) <|> return Override
		clauses		<- parseClauses nm
		let untypedFunc	= SFunction nm tps clauses


		(nm, function)	<- typeFunction syntax types untypedFunc
					& lift
		return $ cons nm function






relationOption	:: Syntax -> Map Symbol Relation -> Parser u (DefaultChange Symbol Relation)
relationOption syntax rels
 = try (do	inWs $ string "Delete"
		symb	<- relationSymb syntax
		return $ Delete symb
		)
   <|> try (do	cons	<- inWs (string "Rename" >> return OverrideAs) 
				<|> (string "Copy" >> return EditAs)
		symb	<- relationSymb syntax
		inWs (string "to" <|> string "as")
		nsymb	<- relationSymb syntax
		
		pronounce <- optionMaybe $ do
			inWs $ char ','
			inWs $ string "pronounced as"
			dqString

		let oldTyping	= (rels M.! symb) & get relTypesModes
		return $ cons symb nsymb (Relation nsymb oldTyping pronounce)
		)



ruleChange	:: TypeSystem -> Parser u (DefaultChange Name Rule)
ruleChange ts	=  parseRule (get tsSyntax ts, get tsRelations ts, get tsFunctions ts) |> (\r -> Override (get ruleName r) r)






changesFile	:: TypeSystem -> Name -> Parser u (Changes, TypeSystem)
changesFile ts0 name
	= do	name'	<- option name $ try $ do
				nls 
				n	<- inWs (try identifier <|> iDentifier)
				nl
				inWs $ many1 $ char '*'
				return n

		-- SYNTAX --
		------------

		bnfs	<- option [] $ try $ do 
				nls
				header "New Syntax"
				nls1
				many (try (nls >> parseBnfRule)) 


		bnfCh	<- option [] $ try $ do
				nls
				header "Syntax Changes"
				nls1
				defaultChanges identifier syntaxChange
		let bnfCh'	= (bnfs |> uncurry New) ++ bnfCh



		ts1	 <- lift $ applySyntaxChanges bnfCh' ts0

		-- FUNCTIONS --
		---------------

 		newFuncs <- option M.empty $ try$ do
				nls
				header "New Functions"
				nls1
				parseFunctions (get tsFunctions ts1 |> typesOf & Just) (get tsSyntax ts1)

		let newFuncs'	= newFuncs & M.toList |> uncurry New

		functions'	<- lift $ get tsFunctions ts1 & applyAllChanges (editFunction (get tsSyntax ts1)) newFuncs'

		funcCh	<- option [] $ try $ do
				nls
				header "Function Changes"
				nls1
				defaultChanges identifier $ functionChange (functions' |> typesOf) (get tsSyntax ts1)

		let funcCh'	= newFuncs' ++ funcCh
		
		ts2	<- lift $ applyFuncChanges funcCh' ts1

		-- RELATIONS --
		---------------

		let relationDict	= get tsRelations ts2 |> (get relSymbol &&& id) & M.fromList

		
		newRels	<- option [] $ try $ do
				nls
				header "New Relations"
				nls1
				many $ try (nls *> relationDecl (get tsSyntax ts2) <* nls)
		let newRels'	= newRels |> (\r -> New (get relSymbol r) r)
		
		relCh	<- option [] $ try $ do
				nls
				header "Relation Changes"
				nls1
				
				many $ try (nls >> relationOption (get tsSyntax ts2) relationDict)

		let relCh'	= newRels' ++ relCh
		
		ts3		<- lift $ applyRelChanges relCh' ts2


		-- Rules --
		---------------


		newRules <- option [] $ try $ do
				nls
				header "New Rules"
				nls1
				parseRules (get tsSyntax ts3, get tsRelations ts3, get tsFunctions ts3)
		let newRules'	= newRules |> (\r -> New (get ruleName r) r)
		
		ruleCh	<- option [] $ try $ do
				nls
				header "Rule Changes"
				nls1
				defaultChanges lineName $ ruleChange ts3

		let ruleCh'	= newRules' ++ ruleCh

		
		tsFinal		<- lift $ applyRuleChanges ruleCh' ts3

		nls
		eof


		lift $ check tsFinal 
		return (Changes name' bnfCh' funcCh' relCh ruleCh', applyNameChange name' tsFinal)





parseChangesFile	:: TypeSystem -> String -> IO (Either String (Changes, TypeSystem))
parseChangesFile ts fp
	= do	input	<- readFile fp
		return $ parseChanges ts input (Just fp)

parseChanges	:: TypeSystem -> String -> Maybe String -> Either String (Changes, TypeSystem)
parseChanges ts input file
	= do	let nme	= fromMaybe "unknown source" file
	  	parsed	<- runParserT (changesFile ts nme) () nme input
		parsed & BF.first show

