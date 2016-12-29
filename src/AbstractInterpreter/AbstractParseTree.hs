module AbstractInterpreter.AbstractParseTree where

{-
This module defines an abstract type tree
-}
import Prelude hiding (subtract)
import Utils.Utils
import Utils.ToString
import TypeSystem
import Utils.Unification

import Data.Map
import qualified Data.Set as S
import Data.Set (Set)
import Data.List as L
import Data.List (intercalate, intersperse, nub)

import Control.Arrow ((&&&))
import Control.Monad

data AbstractSet'
	= EveryPossible MInfo Name TypeName	-- The name is used to identify different expressions, used to diverge on pattern matching
	| ConcreteLiteral MInfo String
	| ConcreteIdentifier MInfo Name
	| ConcreteInt MInfo Name
	| AsSeq MInfo [AbstractSet']		-- Sequence
	deriving (Ord, Eq, Show)


isEveryPossible			:: AbstractSet' -> Bool
isEveryPossible EveryPossible{}	= True
isEveryPossible _		= False


-- erases variable names and producing rules
eraseDetails	:: AbstractSet' -> AbstractSet'
eraseDetails (EveryPossible mi _ tn)
		= EveryPossible (tn, -1) "" tn
eraseDetails (ConcreteLiteral mi s)
		= ConcreteLiteral (_eMI mi) s
eraseDetails (ConcreteIdentifier mi _)
		= ConcreteIdentifier (_eMI mi) ""
eraseDetails (ConcreteInt mi _)
		= ConcreteInt (_eMI mi) ""
eraseDetails (AsSeq mi ass)
		= ass |> eraseDetails & AsSeq (_eMI mi)

sameStructure	:: AbstractSet' -> AbstractSet' -> Bool
sameStructure as bs
	= eraseDetails as == eraseDetails bs


_eMI (tn, _)	= (tn, -1)


replaceAS	:: AbstractSet' -> [Int] -> AbstractSet' -> AbstractSet'
replaceAS _ [] toPlace	= toPlace
replaceAS (AsSeq mi orig) (i:rest) toPlace
 | length orig <= i
	= error $ "Invalid substitution path: index "++show i++" to big for " ++toParsable' " " orig
 | otherwise
	= let	(init, head:tail)	= splitAt i orig
		head'		= replaceAS head rest toPlace in
		(init ++ (head':tail)) & AsSeq mi
replaceAS rest path toReplace
	= error $ "Invalid substitution path: not a sequence, but trying to execute the path "++show path++" on " ++toParsable rest


asAS	:: Expression -> AbstractSet'
asAS (MParseTree (MLiteral mi s))	= ConcreteLiteral mi s
asAS (MParseTree (MIdentifier mi n))	= ConcreteIdentifier mi "?"
asAS (MParseTree (MInt mi i))		= ConcreteInt mi "?"
asAS (MParseTree (PtSeq mi pts))	= pts |> MParseTree |> asAS & AsSeq mi
asAS (MVar tp _)	= EveryPossible ("?", -1) "?" tp
asAS (MSeq mi exprs)	= exprs |> asAS & AsSeq mi 
asAS (MCall tp _ _ _)	= EveryPossible ("fc", -1) "function call" tp
asAS (MAscription tp e)	= asAS e
asAS MEvalContext{}	= error "No contexts allowed here"

instance SimplyTyped AbstractSet' where
	typeOf as	= _typeOf as & either id fst

instance Node AbstractSet' where
	hasChildren (AsSeq _ as)	= not $ L.null as
	hasChildren _	= False
	
	getChildren (AsSeq _ as)	= as

	newChildren (AsSeq mi _)	= AsSeq mi

	sameSymbol (AsSeq mi0 _) (AsSeq mi1 _)	
				= True
	sameSymbol a b		= a == b

	isVar EveryPossible{}		= True
	isVar _				= False

	getName (EveryPossible _ n _)	= n

	
_typeOf (EveryPossible mi _ _)		= Right mi
_typeOf (ConcreteLiteral mi _)		= Right mi
_typeOf (ConcreteIdentifier mi _)	= Right mi
_typeOf (ConcreteInt mi _)		= Right mi
_typeOf (AsSeq mi _)			= Right mi



alwaysIsA'		:: Syntax -> AbstractSet' -> AbstractSet' -> Bool
alwaysIsA' syntax (EveryPossible _ _ tn0) (EveryPossible _ _ tn1)
			= alwaysIsA syntax tn0 tn1

type AbstractSet	= (Syntax, AbstractSet')

typeOf' as	= typeOf $ snd as


generateAbstractSet	:: Syntax -> Name -> TypeName -> AbstractSet
generateAbstractSet r n tm
			= (r, generateAbstractSet' r n tm)


generateAbstractSet'	:: Syntax -> Name -> TypeName -> AbstractSet'
generateAbstractSet' r n tm
			= _generateAbstractSet' r (tm, -1) n (BNFRuleCall tm)


_generateAbstractSet'			:: Syntax -> (TypeName, Int) -> Name -> BNF -> AbstractSet'
_generateAbstractSet' r mi n (Literal s)	= ConcreteLiteral mi s
_generateAbstractSet' r mi n Identifier		= ConcreteIdentifier mi n
_generateAbstractSet' r mi n Number		= ConcreteInt mi n
_generateAbstractSet' r mi n (BNFRuleCall tp)
	| tp `member` getBNF r
			= EveryPossible mi n tp
	| otherwise	= error $ "No bnf-rule with the name " ++ tp
_generateAbstractSet' r mi n (BNFSeq bnfs)
			= mapi bnfs |> (\(i, bnf) -> _generateAbstractSet' r mi (n++":"++show i) bnf) & AsSeq mi


unfold		:: AbstractSet -> [AbstractSet]
unfold (r, as)	= zip (repeat r) (unfold' r as)

unfold'		:: Syntax -> AbstractSet' ->  [AbstractSet']
unfold' r (EveryPossible _ n e)
		= let	bnfs	= getBNF r ! e
		  	choices	= mapi bnfs |> (\(i, bnf) -> _generateAbstractSet' r (e, i) (n++"/"++show i) bnf)
		  in choices & nub
unfold' r as	= [as]


{- Given abstract sets, removes the second from this set
e.g.

a	::= "x" | "y" | b
b	::= a "~" b

subtract [a] b	--> "x" | "y"
subtract [a] "x"	--> "y" | b	-- note that b still can contain an 'x'

-}
subtract	:: Syntax -> [AbstractSet'] -> AbstractSet' -> [AbstractSet']
subtract syntax ass minus
	= do	as	<- nub ass
		guard $ not $ sameStructure as minus
		let unfolded	= unfold' syntax as
		let subbed	= subtract syntax unfolded minus
		let doUnfold	= isEveryPossible as 
					&& alwaysIsA syntax (typeOf minus) (typeOf as) 
					&& subbed /= unfolded
		if not doUnfold then return as else subbed

subtractAll	:: Syntax -> [AbstractSet'] -> [AbstractSet'] -> [AbstractSet']
subtractAll	= L.foldl . subtract


instance ToString AbstractSet' where
	toParsable (EveryPossible _ _ name)	= name 
	toParsable (ConcreteLiteral _ s)	= show s
	toParsable (ConcreteIdentifier _ nm)	= "Identifier"
	toParsable (ConcreteInt _ nm)		= "Number"
	toParsable (AsSeq _ ass)		= ass |> toParsable & unwords & inParens
	
	toCoParsable (EveryPossible _ _ name)	= name 
	toCoParsable (ConcreteLiteral _ s)	= show s
	toCoParsable (ConcreteIdentifier _ nm)	= "Identifier:"++nm
	toCoParsable (ConcreteInt _ nm)		= "Number:"++nm
	toCoParsable (AsSeq _ ass)		= ass |> toCoParsable & unwords & inParens


	debug	= show
