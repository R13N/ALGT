 {-# LANGUAGE TemplateHaskell, OverloadedStrings #-}
module Utils.Image where

{- Imagetools, like drawing dots with text -}

import Utils.Utils
import Text.Blaze.Svg11 ((!), stringValue)
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A

import Text.Blaze.Svg.Renderer.String (renderSvg)-- DO NOT USE THE PRETTY RENDERER; text won't be centered then
import Data.Text (Text)
import qualified Data.Text as Text

import Data.Map (Map, findWithDefault)

import Lens.Micro hiding ((&))
import Lens.Micro.TH

import Control.Monad




data ColorScheme	= CS {	_fg		:: String,
				_bg		:: String,
				_lineColor	:: String,
				_fontSize	:: Int,
				_lineThickness	:: Int,
				_dotSize	:: Int
				}
terminalCS	= CS "#00ff00" "#000000" "#00ff00" 20 1 4
whiteCS		= CS "#000000" "#ffffff" "#000000" 20 1 4

makeLenses ''ColorScheme

type X	= Int
type Y 	= Int

type W	= Int
type H	= Int



intValue	:: Int -> S.AttributeValue
intValue i	= stringValue $ show i



packageSVG	:: (Int, Int) -> (Int, Int) -> S.Svg -> String
packageSVG (pxW, pxH) (viewBoxW, viewBoxH) svg
	= let	svg'	= S.docTypeSvg	! A.version "1.1"
					! A.width (intValue pxW)
					! A.height (intValue pxH)
					! A.viewbox (stringValue $ "0 0 "++show viewBoxW++" "++show viewBoxH)
					$ svg
		in
		renderSvg svg'



drawLineBetween	:: ColorScheme -> Bool -> Map Text (X, Y) -> Text -> Text -> S.Svg
drawLineBetween cs dashed coors start end
	= do	let (start', end')	= lookupPoints coors (start, end)
		drawLine cs dashed start' end'

lookupPoints	:: Map Text (X, Y) -> (Text, Text) -> ((X, Y), (X, Y))
lookupPoints coors (start, end)
	= let	find x	= findWithDefault (error $ "Images: I do not know what "++Text.unpack x++" is") x coors 
		start'	= find start
		end'	= find end
		in (start', end')



linesIntersect	:: ((X, Y), (X, Y)) -> ((X, Y), (X, Y)) -> Bool
linesIntersect (e@(ex, ey), f@(fx, fy)) (p@(px, py), q@(qx, qy))
 | e == p || e == q || f == p || f == q
		= False
 | otherwise
		= let	side0	= (fx - ex)*(py - fy) - (fy - ey)*(px - fx)
			side1	= (fx - ex)*(qy - fy) - (fy - ey)*(qx - fx)
			in
			signum side0 /= signum side1
			



drawLine	:: ColorScheme -> Bool -> (X, Y) -> (X, Y) -> S.Svg
drawLine cs dashed (x0,y0) (x1, y1)
	= let 	lt	= get lineThickness cs
		pth = S.path ! A.d (stringValue $ ["M", show x0, show y0, ","
						, show x1, show y1] & unwords) 
			! A.stroke (stringValue $ get lineColor cs)
			! A.strokeWidth (intValue $ get lineThickness cs)
			! A.strokeLinecap "round"
	   in if dashed then pth ! A.strokeDasharray (stringValue $ [show lt, ",", show $ 5 * lt] & unwords) else pth

{-
Height: 
fs * 3
-}
annotatedDot	:: ColorScheme -> Bool -> (Text, (X, Y)) -> S.Svg
annotatedDot cs under (nm, (x, y))
	= do	let fs	= get fontSize cs
		let nml	= Text.length nm
		let rW	= round $ fromIntegral (fs * nml) * 0.65
		let offsetY	= if under then fs `div` 2 else negate 2 * fs
		unless (Text.null nm) $ do 
			S.rect ! A.x (intValue $ x - rW `div` 2)
				! A.y (intValue $ y + offsetY ) 
				! A.width (intValue rW)
				! A.height (intValue $ fs + fs `div` 2)
				! A.fill (stringValue $ get bg cs)
				! A.fillOpacity "0.5"
			S.text_ ! A.x (intValue x)
				! A.y (intValue $ y + fs + offsetY) 
				! A.fontSize (intValue fs)
				! A.textAnchor (stringValue "middle")
				! A.fontFamily "mono"
				! A.fill (stringValue $ get fg cs)
				$ S.text  nm
		S.circle ! A.r (intValue $ get dotSize cs) ! A.cx (intValue x) ! A.cy (intValue y) ! A.fill (stringValue $ get fg cs)


