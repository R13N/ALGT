module FunctionInterpreter where

{-
This module defines an interpreter for functions. functions are evaluated here
-}

import Utils
import TypeSystem

import Control.Monad

import qualified Data.Map as M
import Data.Map (Map)
import Data.Maybe
import Data.List (intercalate, intersperse)
import Data.Bifunctor (first)

evalFunc	:: TypeSystem -> Name -> [ParseTree] -> ParseTree
evalFunc ts funcName args	
 | funcName `M.member` tsFunctions ts
	= let	func	= tsFunctions ts M.! funcName in
		applyFunc (buildCtx' ts) (funcName, func) args
 | otherwise
	= evalErr (Ctx (tsSyntax ts) (tsFunctions ts) M.empty []) $
		"evalFunc with unknown function: "++funcName	

evalExpr	:: TypeSystem -> VariableAssignments -> Expression -> ParseTree
evalExpr ts vars e	
	= evaluate (buildCtx ts vars) e

type VariableAssignments
		= Map Name (ParseTree, Maybe [Int])	-- If a path of numbers (indexes in the expression-tree) is given, it means a evaluation context is used
data Ctx	= Ctx { ctx_syntax	:: BNFRules,		-- Needed for typecasts
			ctx_functions 	:: Map Name Function,
			ctx_vars	:: VariableAssignments,
			ctx_stack	:: [(Name, [ParseTree])] -- only used for errors
			}

buildCtx ts vars 	= Ctx (tsSyntax ts) (tsFunctions ts) vars []
buildCtx' ts		= buildCtx ts M.empty


-- applies given argument to the  function. Starts by evaluating the args
applyFunc	:: Ctx -> (Name, Function) -> [ParseTree] -> ParseTree
applyFunc ctx (nm, MFunction tp clauses) args
	= let	stackEl	= (nm, args)
		ctx'	= ctx {ctx_stack = stackEl:ctx_stack ctx}
		clauseResults	= clauses |> evalClause ctx' args & catMaybes
		in if null clauseResults then error $ "Not a single clause matched, even with error injection. This is a bug!" else
			head clauseResults


evalClause	:: Ctx ->  [ParseTree] -> Clause -> Maybe ParseTree
evalClause ctx args (MClause pats expr)
	= do	variabless	<- zip pats args |+> uncurry (patternMatch (ctx_syntax ctx) (const True))
		variables	<- mergeVarss variabless
		let ctx'	= ctx {ctx_vars = variables}
		return $ evaluate ctx' expr


mergeVarss	:: [VariableAssignments] -> Maybe VariableAssignments
mergeVarss	= foldM mergeVars M.empty

mergeVars	:: VariableAssignments -> VariableAssignments -> Maybe VariableAssignments
mergeVars v1 v2
	= do	let common	= (v1 `M.intersection` v2) & M.keys
		let cv1		= common |> (v1 M.!)
		let cv2		= common |> (v2 M.!)
		if cv1 == cv2 
			then return (v1 `M.union` v2)
			else Nothing

{-
Disasembles an expression against a pattern
patternMatch pattern value

The extra function (VariableAssignments -> Bool) injects a test, to test different evaluation contexts
-}
patternMatch	:: BNFRules -> (VariableAssignments -> Bool) -> Expression -> ParseTree -> Maybe VariableAssignments
patternMatch _ _ (MVar _ v) expr
	= Just $ M.singleton v (expr, Nothing)
patternMatch _ _ (MParseTree (MLiteral _ s1)) (MLiteral _ s2)
	| s1 == s2		= Just M.empty
	| otherwise		= Nothing
patternMatch _ _ (MParseTree (MInt _ s1)) (MInt _ s2)
	| s1 == s2		= Just M.empty
	| otherwise		= Nothing
patternMatch _ _ (MParseTree (MIdentifier _ s1)) (MIdentifier _ s2)
	| s1 == s2		= Just M.empty
	| otherwise		= Nothing
patternMatch r f (MParseTree (PtSeq mi pts)) pt
	= patternMatch r f (MSeq mi (pts |> MParseTree)) pt
patternMatch r f (MSeq _ seq1) (PtSeq _ seq2)
 | length seq1 /= length seq2	= Nothing
 | otherwise			= zip seq1 seq2 |+> uncurry (patternMatch r f) >>= foldM mergeVars M.empty

patternMatch r f (MAscription as expr') expr
 | alwaysIsA r (typeOf expr) as	
	= patternMatch r f expr' expr
 | otherwise	
	= Nothing

patternMatch r extraCheck (MEvalContext tp name hole) value@(PtSeq _ _)
	= patternMatchContxt r extraCheck (tp, name, hole) value
		

patternMatch _ _ (MCall _ "error" True _) _	
	= error $ "Using an error in a pattern match is not allowed. Well, you've got your error now anyway. Happy now, you punk?"
patternMatch _ _ (MCall _ nm _ _) _	
	= error $ "Using a function call in a pattern is not allowed"
patternMatch _ _ pat expr		
	= Nothing


patternMatchContxt	:: BNFRules -> (VariableAssignments -> Bool) -> (TypeName, Name, Expression) -> ParseTree -> Maybe VariableAssignments
patternMatchContxt r extraCheck evalCtx fullContext@(PtSeq _ values)
	= do	let matchMaker	= makeMatch r extraCheck evalCtx fullContext	:: (ParseTree, [Int]) -> Maybe VariableAssignments
		depthFirstSearch' matchMaker [] values


makeMatch	:: BNFRules -> (VariableAssignments -> Bool) -> (TypeName, Name, Expression) -> ParseTree -> (ParseTree, [Int]) -> Maybe VariableAssignments
makeMatch r extraCheck (tp, name, holePattern) fullContext (holeFiller, path)
	= do	let baseAssign	= M.singleton name (fullContext, Just path)	:: VariableAssignments
		holeAssgn	<- patternMatch r extraCheck holePattern holeFiller
		assgn'		<- mergeVars baseAssign holeAssgn
		guard $ extraCheck assgn'
		return assgn'

-- depth first search, excluding self match
depthFirstSearch'	:: ((ParseTree, [Int]) -> Maybe VariableAssignments) -> [Int] -> [ParseTree] -> Maybe VariableAssignments
depthFirstSearch' matchMaker path values
	= do	let deeper	= zip [0..] values |> (\(i, pt) -> depthFirstSearch matchMaker (path++[i]) pt)
		firstJusts deeper

depthFirstSearch	:: ((ParseTree, [Int]) -> Maybe VariableAssignments) -> [Int] -> ParseTree -> Maybe VariableAssignments
depthFirstSearch matchMaker path pt@(PtSeq _ values)
	= do	let deeper	= depthFirstSearch' matchMaker path values
		let self	= matchMaker (pt, path)
		firstJusts [deeper, self]
depthFirstSearch _ _ _	= Nothing		





evaluate	:: Ctx -> Expression -> ParseTree
evaluate ctx (MCall _ "plus" True es)
	= let	(tp, es')	= asInts ctx "plus" es in
		MInt tp (sum es')
evaluate ctx (MCall _ "min" True es)
	= let	(tp, [e1, e2])	= asInts ctx "min" es in
		MInt tp (e1 - e2)
evaluate ctx (MCall _ "neg" True es)
	= let	(tp, [e1])	= asInts ctx "neg" es in
		MInt tp (-e1)
evaluate ctx (MCall _ "equal" True es)
	= let	(tp, [e1, e2])	= asInts ctx "equal" es in
		MInt tp (if e1 == e2 then 1 else 0)
evaluate ctx (MCall _ "error" True exprs)
	= let	exprs'	= exprs |> evaluate ctx & show
		msgs	= ["In evaluating a function:", exprs']
		stack	= ctx_stack ctx |> buildStackEl
		in	error $ unlines $ stack ++ msgs
evaluate ctx (MCall _ "newvar" True [identifier, nonOverlap])
	= case evaluate ctx identifier of
		(MIdentifier (basetype, _) nm)
			-> unusedIdentifier nonOverlap (Just nm) basetype
		expr	-> unusedIdentifier nonOverlap Nothing (typeOf expr)
			
evaluate ctx (MCall _ nm True args)
	= evalErr ctx $ "unknown builtin "++nm++" for arguments: "++showComma args

evaluate ctx (MCall _ nm False args)
 | nm `M.member` ctx_functions ctx
	= let	func	= ctx_functions ctx M.! nm
		args'	= args |> evaluate ctx in
		applyFunc ctx (nm, func) args'
 | otherwise
	= evalErr ctx $ "unknown function: "++nm	

evaluate ctx (MVar _ nm)
 | nm `M.member` ctx_vars ctx	
	= fst $ ctx_vars ctx M.! nm
 | otherwise			
	= evalErr ctx $ "unkown variable "++nm

evaluate ctx (MEvalContext _ nm hole)
 | nm `M.member` ctx_vars ctx	
	= let	hole'	= evaluate ctx hole
		(context, path)	= ctx_vars ctx M.! nm
		path'	= fromMaybe (error $ nm++" was not captured using an evaluation context") path
		in
		replace context path' hole'
 | otherwise			
	= evalErr ctx $ "unkown variable (for evaluation context) "++nm


evaluate ctx (MSeq tp vals)	= vals |> evaluate ctx & PtSeq tp
evaluate ctx (MParseTree pt)	= pt
evaluate ctx e			= evalErr ctx $ "Fallthrough on evaluation in Function interpreter: "++show e++" within context "++show (ctx_vars ctx)


evalErr	ctx msg	= evaluate ctx $ MCall "" "error" True [MParseTree $ MLiteral ("", -1) ("Undefined behaviour: "++msg)]

asInts ctx bi exprs	
	= let 	exprs'	= exprs |> evaluate ctx 
				|> (\e -> if isMInt' e then e else error $ "Not an integer in the builtin "++bi++" expecting an int: "++ show e)
				|> (\(MInt _ i) -> i)
		tp	= typeOf $ head exprs
		tp'	= if tp == "" then error $ "Declare a return type, by annotating the first argument of a builtin" else tp
		in
		((tp', -1), exprs')

buildStackEl	:: (Name, [ParseTree]) -> String
buildStackEl (func, args)
	= "   In "++func++ inParens (args & showComma)
