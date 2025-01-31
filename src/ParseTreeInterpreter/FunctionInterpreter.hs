 {-# LANGUAGE TypeSynonymInstances, FlexibleInstances, MultiParamTypeClasses #-} 
module ParseTreeInterpreter.FunctionInterpreter (evalFunc, evalExpr, VariableAssignments, mergeVars, mergeVarss, patternMatch, buildCtx') where

{-
This module defines an interpreter for functions. 
-}

import TypeSystem
import Utils.ToString
import Utils.Utils

import Control.Monad

import qualified Data.Map as M
import Data.Map (Map)
import Data.Maybe
import Data.List (intercalate, intersperse)
import Data.Bifunctor (first)
import Data.Either

import Control.Arrow ((&&&))

import Lens.Micro hiding ((&))
import Lens.Micro.TH


type VariableAssignments	= VariableAssignmentsA ParseTree

data Ctx	= Ctx { ctxSyntax	:: Syntax,		-- Needed for typecasts
			ctxFunctions 	:: Map Name Function,
			ctxVars		:: VariableAssignments,
			ctxStack	:: [(Name, [ParseTree])] -- only used for errors
			}
buildCtx ts vars 	= Ctx (get tsSyntax ts) (get tsFunctions ts) vars []
buildCtx' ts		= buildCtx ts M.empty





evalFunc	:: TypeSystem -> Name -> [ParseTree] -> Either String ParseTree
evalFunc ts funcName args
	= do	func	<- checkFunctionExists ts funcName	
		applyFunc (buildCtx' ts) (funcName, func) args



evalExpr	:: TypeSystem -> VariableAssignments -> Expression -> Either String ParseTree
evalExpr ts vars
	= evaluate (buildCtx ts vars)




-- applies given argument to the  function. Starts by evaluating the args
applyFunc	:: Ctx -> (Name, Function) -> [ParseTree] -> Either String ParseTree
applyFunc ctx (nm, MFunction tp clauses) args
 | length args /= length tp - 1
	= evalErr ctx $ "Number of arguments does not match. Expected "++show (length tp - 1)++" variables, but got "++show (length args)++" arguments instead"
 | otherwise
	= do	let stackEl		= (nm, args)
		let ctx'		= ctx {ctxStack = stackEl:ctxStack ctx}
		let clauseResults'	= mapi clauses |> evalClause ctx' args 
		let clauseResults	= clauseResults' & rights
		when (null clauseResults) $ Left $ "Not a single clause of "++nm++" matched:\n"++(clauseResults' & lefts & unlines & indent)
		return $ head clauseResults


evalClause	:: Ctx ->  [ParseTree] -> (Int, Clause) -> Either String ParseTree
evalClause ctx args (i, MClause pats expr)
	= do	let stackEl		= ("Pattern matching clause "++show i++" with arguments: ", args)
		variables	<- inMsg ("While pattern matching clause "++show i) $
					patternMatchAll (ctx{ctxStack = stackEl:ctxStack ctx}) pats args
		let ctx'	= ctx {ctxVars = variables}
		evaluate ctx' expr


mergeVarss	:: [VariableAssignments] -> Either String VariableAssignments
mergeVarss	= foldM mergeVars M.empty

mergeVars	:: VariableAssignments -> VariableAssignments -> Either String VariableAssignments
mergeVars v1 v2
	= do	let common	= (v1 `M.intersection` v2) & M.keys
		let cv1		= common |> (v1 M.!)
		let cv2		= common |> (v2 M.!)
		let different	= zip common (zip cv1 cv2) & filter (uncurry (/=) . snd)
		let msg (nm, (assgn1, assgn2))
				= nm++" is assigned both "++ inParens (showAssgn assgn1) ++ " and "++ inParens (showAssgn assgn2)
		let failMsgs	= different |> msg & unlines
		if cv1 == cv2 then return (v1 `M.union` v2)
			else inMsg "Merging contexts failed: some variables are assigned different values" $ Left failMsgs


patternMatchAll	:: Ctx -> [Expression] -> [ParseTree] -> Either String VariableAssignments
patternMatchAll ctx 
	= _patternMatchAll ctx M.empty

_patternMatchAll	:: Ctx -> VariableAssignments -> [Expression] -> [ParseTree] -> Either String VariableAssignments
_patternMatchAll _ _ [] []
		= return M.empty
_patternMatchAll ctx prevVars (pat:pats) (arg:args)
	= do	let successFullMatch vars	
				= do	prevVars'	<- mergeVars prevVars vars
					vars'	<- _patternMatchAll ctx prevVars' pats args
					mergeVars vars vars'
					pass
		variables	<- patternMatch ctx successFullMatch pat arg
		-- only used for the check
		prevVars'	<- mergeVars prevVars variables
		variables'	<- _patternMatchAll ctx prevVars' pats args
		mergeVars variables variables'



{-
Disasembles an expression against a pattern
patternMatch pattern value

The extra function (VariableAssignments -> Bool) injects a test, to test different evaluation contexts
-}
patternMatch	:: Ctx -> (VariableAssignments -> Either String ()) -> Expression -> ParseTree -> Either String VariableAssignments
patternMatch _ _ (MVar _ v) expr
 | v == "_"	= return M.empty
 | otherwise
	= return $ M.singleton v (expr, Nothing)
patternMatch _ _ (MParseTree (MLiteral _ _ s1)) (MLiteral _ _ s2)
	| s1 == s2		= return M.empty
	| otherwise		= Left $ "Not the same literal: "++s1++ " /= " ++ s2
patternMatch _ _ (MParseTree (MInt _ _ s1)) (MInt _ _ s2)
	| s1 == s2		= return M.empty
	| otherwise		=  Left $ "Not the same int: "++show s1++ " /= " ++ show s2
patternMatch ctx f (MParseTree (PtSeq _ mi pts)) pt
	= patternMatch ctx f (MSeq mi (pts |> MParseTree)) pt
patternMatch ctx f s1@(MSeq _ seq1) s2@(PtSeq _ _ seq2)
 | length seq1 /= length seq2	= Left $ "Sequence lengths are not the same: "++toParsable s1 ++ " /= "++toCoParsable s2
 | otherwise			= zip seq1 seq2 |+> uncurry (patternMatch ctx f) >>= foldM mergeVars M.empty

patternMatch ctx f (MAscription as expr') expr
 | alwaysIsA (ctxSyntax ctx) (typeOf expr) as	
	= patternMatch ctx f expr' expr
 | otherwise	
	= Left $ toCoParsable expr ++" is not a "++show as

patternMatch ctx extraCheck (MEvalContext tp name hole) value@PtSeq{}
	= patternMatchContxt ctx extraCheck (tp, name, hole) value
patternMatch ctx extraCheck (MEvalContext tp name hole) literal
	= Left "Evaluation contexts only searching within a parse tree and don't handle literals"

patternMatch ctx _ func@MCall{} arg
	= do	pt	<- evaluate ctx func
		unless (pt == arg) $ Left $ "Function result of "++toParsable func++" does not equal the given argument"
		return M.empty
patternMatch ctx _ pat expr		
	= let 	stack	= ctxStack ctx |> buildStackEl & unlines in
		inMsg stack $ Left $ "FT: Could not pattern match '"++toCoParsable expr++"' over '"++toParsable pat++"'"


patternMatchContxt	:: Ctx -> (VariableAssignments -> Either String ()) -> (TypeName, Name, Expression) -> ParseTree -> Either String VariableAssignments
patternMatchContxt r extraCheck evalCtx@(tp, nm, expr) fullContext@(PtSeq _ _ values)
	= inMsg ("While pattern matching evaluation context "++toParsable (MEvalContext tp nm expr)) $
	  do	let matchMaker (pt, p)	
			= inMsg ("While trying to fill the hole with '" ++ toParsable pt++"'") $ makeMatch r extraCheck evalCtx fullContext (pt, p)	
					:: Either String VariableAssignments
		inMsg "While searching a value to fill the hole" $ depthFirstSearch' matchMaker [] values


makeMatch	:: Ctx -> (VariableAssignments -> Either String ()) -> (TypeName, Name, Expression) -> ParseTree -> (ParseTree, Path) -> Either String VariableAssignments
makeMatch ctx extraCheck (tp, name, holePattern) fullContext (holeFiller, path)
	= do	let baseAssign	= M.singleton name (fullContext, Just path)	:: VariableAssignments
		holeAssgn	<- patternMatch ctx extraCheck holePattern holeFiller
		assgn'		<- mergeVars baseAssign holeAssgn
		inMsg "Testing extra patterns/predicates" $ extraCheck assgn'
		return assgn'

-- depth first search, excluding self match
depthFirstSearch'	:: ((ParseTree, Path) -> Either String VariableAssignments) -> Path -> [ParseTree] -> Either String VariableAssignments
depthFirstSearch' matchMaker path values
	= do	let deeper	= zip [0..] values |> (\(i, pt) -> depthFirstSearch matchMaker (path++[i]) pt)
		firstRight deeper

depthFirstSearch	:: ((ParseTree, Path) -> Either String VariableAssignments) -> Path -> ParseTree -> Either String VariableAssignments
depthFirstSearch matchMaker path pt@(PtSeq _ _ values)
	= do	let deeper	= depthFirstSearch' matchMaker path values
		let self	= matchMaker (pt, path)
		firstRight [deeper, self]
depthFirstSearch matchMaker path pt	
	= matchMaker (pt, path)










_applyBuiltinFunction'	:: Ctx -> Name -> TypeName -> [Expression] -> Either String ParseTree
_applyBuiltinFunction' ctx funcName tp es
	= do	bif	<- checkExists funcName builtinFunctions' ("No builtin function with name "++funcName++" found")
		_applyBuiltinFunction ctx tp bif es


_applyBuiltinFunction	:: Ctx -> TypeName -> BuiltinFunction -> [Expression] -> Either String ParseTree
_applyBuiltinFunction ctx tp (BuiltinFunction "error" _ _ _ f) es
	= do	pt		<- f & _runBIFunc ctx "error" tp es	-- The message
		let stack	= ctxStack ctx |> buildStackEl & reverse
		Left $ unlines $ stack ++ [toParsable pt]
_applyBuiltinFunction ctx tp (BuiltinFunction funcName _ (Right fixedTypes) retType f) es
	-- In this case, we have a fixed type and can just apply our function! The typechecker will make sure it's fine
	= f & _runBIFunc ctx funcName tp es
_applyBuiltinFunction ctx tp (BuiltinFunction funcName _ (Left (_, atLeastNeeded)) _ f) es
	-- We have a variable number of elements, we check there are enough of them
	= do	let minimumOK	= length es >= atLeastNeeded
		unless minimumOK $ Left $ "Builtin function '!" ++ funcName++"' needs at least "++show atLeastNeeded ++" arguments"
		f & _runBIFunc ctx funcName tp es

_runBIFunc	:: Ctx -> Name -> TypeName -> [Expression] -> Either ([Int] -> Int) (TypeName -> [ParseTree] -> ParseTree) -> Either String ParseTree
_runBIFunc ctx funcName _ es (Left intFunc)
	= do 	is	<- asInts ctx funcName es	-- asInts does evaluation as well
		return $ MInt () ("Number", 0) (intFunc is)
_runBIFunc ctx _ tp es (Right ptFunc)
	= do	es'	<- es |+> evaluate ctx
		return $ ptFunc tp es'
			


evaluate	:: Ctx -> Expression -> Either String ParseTree
evaluate ctx (MCall tp nm True es)
	= _applyBuiltinFunction' ctx nm tp es

evaluate ctx (MCall _ nm False args)
 | nm `M.member` ctxFunctions ctx
	= do	let func	= ctxFunctions ctx M.! nm
		args'		<- args |+> evaluate ctx
		applyFunc ctx (nm, func) args'
 | otherwise
	= evalErr ctx $ "unknown function: "++nm	

evaluate ctx (MVar _ nm)
 | nm `M.member` ctxVars ctx	
	= return $ fst $ ctxVars ctx M.! nm
 | otherwise			
	= evalErr ctx $ "unkown variable "++nm

evaluate ctx (MEvalContext _ nm hole)
 | nm `M.member` ctxVars ctx	
	= do	hole'	<- evaluate ctx hole
		let (context, path)	= ctxVars ctx M.! nm
		path'	<- maybe (Left $ nm++" was not captured using an evaluation context") return path
		return $ replace context path' hole'
 | otherwise			
	= evalErr ctx $ "unkown variable (for evaluation context) "++nm


evaluate ctx (MSeq tp vals)	= do	vals'	<- vals |+> evaluate ctx 
					return $ PtSeq () tp vals'
evaluate ctx (MParseTree pt)	= return pt
evaluate ctx (MAscription tn expr)
				= evaluate ctx expr



showVarAssgn	:: (Name, (ParseTree, Maybe Path)) -> String
showVarAssgn (nm, assgn)
	= nm ++ " = "++ showAssgn assgn

showAssgn	:: (ParseTree, Maybe Path) -> String
showAssgn (pt, mPath)
		= toParsable pt++
		maybe "" (\path -> "\tContext path is "++show path) mPath

evalErr		:: Ctx -> String -> Either String ParseTree
evalErr	ctx msg	= evaluate ctx $ MCall "" "error" True [MParseTree $ MLiteral () ("", -1) ("Undefined behaviour: "++msg)]

asInts ctx bi exprs	
	= exprs |+> evaluate ctx 
		|++> (\e -> if isMInt' e then return e else Left $ "Not an Number in the builtin "++show ('!':bi) ++": "++ toParsable e)
		||>> (\(MInt _ _ i) -> i)

buildStackEl	:: (Name, [ParseTree]) -> String
buildStackEl (func, args)
	= let	shorten arg	= if length arg > 24 then take 21 arg ++ "..." else arg 
		noNL arg	= arg & filter (/= '\n') in
		"   In "++func++ inParens (args |> toParsable |> shorten |> noNL & intercalate ", ")




