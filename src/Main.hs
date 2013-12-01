{-# LANGUAGE NoMonomorphismRestriction, FlexibleContexts, TypeFamilies, GADTs, ViewPatterns #-}
module Main where

import Diagrams.Prelude
import Diagrams.TwoD.Tilings
import Diagrams.Backend.Cairo
import Diagrams.Backend.Cairo.CmdLine
import System.Random
import Data.Colour.SRGB

hexagonTiling :: Double -> Double -> [Polygon]
hexagonTiling w h = generateTiling t6 (0,0) (1,0) inRect (const []) return
  where
    inRect ((unr2 . toR2) -> (x,y)) = -w/2 <= x && x <= w/2 && -h/2 <= y && y <= h/2

drawDandelion :: Style R2 -> Style R2 -> Polygon -> IO (Diagram B R2)
drawDandelion bg fg poly =
    do r <- getStdRandom (randomR (0,5))
       let [q0, q1, q2, q3, q4, q5] = take 6 . drop r . cycle . polygonVertices $ poly
           diagonals = map (mkEdge q0) [q2, q2 `midpoint` q3, q3, q3 `midpoint` q4, q4]
       return $ mconcat (map (drawEdge fg) diagonals) <> drawPoly (const bg) poly
  where
    p `midpoint` q = p ^+^ (0.5 *^ (q ^-^ p))

lawngreen = sRGB24read "#0e8706"

dia :: IO (Diagram Cairo R2)
dia = do dandelions <- mconcat `fmap` mapM (drawDandelion hexStyle diagStyle) tiles
         return (dandelions # bg Main.lawngreen)
  where
    tiles = hexagonTiling 25 26
    diagStyle = mempty # lc white # lwG 0.04
    hexStyle = mempty # lc white # lwG 0.025 # lineCap LineCapRound

main = dia >>= defaultMain
