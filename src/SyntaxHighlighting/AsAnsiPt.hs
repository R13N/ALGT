module SyntaxHighlighting.AsAnsiPt where

{-  Renders a parsetree with ANSI-Strings -}

import Utils.Utils
import Utils.ToString

import qualified Assets
import TypeSystem
import TypeSystem.Parser.TargetLanguageParser

import Text.PrettyPrint.ANSI.Leijen as ANSI

import SyntaxHighlighting.Coloring
import SyntaxHighlighting.Renderer
import Data.List as L
import Data.Maybe
import Data.Char

import System.IO

import Control.Arrow ((&&&))

import Lens.Micro hiding ((&))



data AnsiRenderer	= AnsiRenderer FullColoring SyntaxStyle

instance Renderer AnsiRenderer where
	create	= AnsiRenderer
	name _	= "Ansi"
	renderParseTree' pt (AnsiRenderer fc style)
		= renderPT fc style (deAnnot pt)
	renderParseTree pt (AnsiRenderer fc style)
		= renderPT fc style pt
	renderParseTreeDebug pt (AnsiRenderer fc style)
		= renderPTDebug fc style pt
	renderString styleName str (AnsiRenderer fc _)
		= renderWithStyle fc styleName str
	supported _	= properties |> fst
	
	 


renderPT	:: FullColoring -> SyntaxStyle -> ParseTree -> Doc
renderPT fc style pt
	= let	ptannot		= determineStyle' style pt
		ptannot'	= ptannot ||>> renderWithStyle fc & cascadeAnnot (renderWithStyle fc "")	:: ParseTreeA (String -> Doc)
		in
		renderDoc ptannot'


renderDoc	:: ParseTreeA (String -> Doc) -> Doc
renderDoc (MLiteral f _ s)
		= f s
renderDoc (MInt f _ i)
		= f $ show i
renderDoc (PtSeq _ _ pts)
		= pts |> renderDoc & foldl1 (<+>)

renderPTDebug	:: FullColoring -> SyntaxStyle -> ParseTree -> Doc
renderPTDebug fc style pt
	= let	ptannot		= annot () pt & determineStyle style |> snd	:: ParseTreeA (Maybe Name)
		ptannot'	= ptannot ||>> renderWithStyle fc & cascadeAnnot text	:: ParseTreeA (String -> Doc)
		(meta, docs)	= renderDocDebug ptannot' & unzip
		meta'		= meta |> text |> yellow
		l		= docs |> show |> length & maximum 
		docs'		= docs |> padR' (l+3) (length . show) (text " ")	:: [Doc] 
		in
		zip docs' meta' |> uncurry (<+>) & foldl1 (ANSI.<$>)

styleMI		:: ParseTreeA a -> String
styleMI pt'	= get ptaInf pt' & (\(tn, i) -> tn++ "." ++ show i)

renderDocDebug	:: ParseTreeA (String -> Doc) -> [(String, Doc)]
renderDocDebug (PtSeq _ _ pts)
		= let	(meta, h:t)	= (pts >>= renderDocDebug) & unzip in
			zip meta $ (text "+ " <+> h) : (t |> ( text "| " <+>))
renderDocDebug pt
		= [(styleMI pt, renderDoc pt)]


renderWithStyle	:: FullColoring -> Name -> String ->  Doc
renderWithStyle fc styleN str
	= let	effect	= properties |> applyProperty fc styleN & chain
		in
		effect $ text str

applyProperty	:: FullColoring -> Name -> (Name, Either Int String -> Doc -> Doc) -> Doc -> Doc
applyProperty fc style (prop, effect)
	= getProperty fc style prop |> effect & fromMaybe id


properties	:: [(Name, Either Int String -> Doc -> Doc)]
properties
      = [ ("foreground-color", fst . closestColor)
	, ("background-color", snd . closestColor)
	, ("font-style", either (const id) (\v -> fromMaybe (debold . deunderline) $ L.lookup v styles))
	]


closestColor	:: Either Int String -> (Doc -> Doc, Doc -> Doc)
closestColor (Left c)	= closestColor $ Right $ intAsColor c
closestColor (Right c)
	= colors |> over _1 (colorDistance c)
		& sortOn fst
		& head & snd

colors	:: [(String, (Doc -> Doc, Doc -> Doc))]
colors
      = [ ("#000000", (dullblack, id))
	, ("#ff0000", (red, onred))
	, ("#00ff00", (green, ongreen))
	, ("#0000ff", (blue, onblue))
	, ("#ffff00", (yellow, onyellow))
	, ("#ff00ff", (magenta, onmagenta))
	, ("#00ffff", (cyan, oncyan))
	, ("#ffffff", (white, onwhite))
	
	, ("#808080", (black, onblack))
	, ("#C0C0C0", (dullwhite, ondullwhite))
	, ("#800000", (dullred, ondullred))
	, ("#008000", (dullgreen, ondullgreen))
	, ("#000080", (dullblue, ondullblue))
	, ("#808000", (dullyellow, ondullyellow))
	, ("#800080", (dullmagenta, ondullmagenta))
	, ("#008080", (dullcyan, ondullcyan))
	] 

styles	:: [(String, Doc -> Doc)]
styles
      = [ ("normal", deunderline . debold)
	, ("underline", underline . debold)
	, ("bold", bold . deunderline)
	, ("underlinedbold", underline . bold)
	]


