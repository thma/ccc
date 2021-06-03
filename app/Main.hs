{-# LANGUAGE CPP                     #-}
{-# LANGUAGE FlexibleContexts        #-}
{-# LANGUAGE TypeApplications        #-}
{-# LANGUAGE ScopedTypeVariables     #-}
{-# LANGUAGE ConstraintKinds         #-}
{-# LANGUAGE TypeFamilies            #-}
{-# LANGUAGE TypeOperators           #-}
{-# LANGUAGE DataKinds               #-}

-- For OkLC as a class
{-# LANGUAGE UndecidableInstances    #-}
{-# LANGUAGE FlexibleInstances       #-}
{-# LANGUAGE MultiParamTypeClasses   #-}

{-# OPTIONS_GHC -Wall #-}

{-# OPTIONS -Wno-type-defaults #-}

{-# OPTIONS_GHC -Wno-missing-signatures #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

{-# OPTIONS_GHC -fsimpl-tick-factor=500 #-}
{-# OPTIONS_GHC -dsuppress-idinfo #-}
{-# OPTIONS_GHC -fdicts-strict #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Main where

import Prelude hiding (unzip,zip,zipWith) -- (id,(.),curry,uncurry)
import qualified Prelude as P

import Data.Monoid (Sum(..))
import Data.Foldable (fold)
import Control.Applicative (liftA2)
import Control.Arrow (second)
import Control.Monad ((<=<))
import Data.List (unfoldr)  -- TEMP
import Data.Complex (Complex)
import GHC.Float (int2Double)



import qualified ConCat.AltCat as A
import ConCat.AltCat
 (toCcc,toCcc',unCcc,unCcc',conceal,(:**:)(..),Ok,Ok2,U2,equal)

import ConCat.Rebox

import ConCat.Circuit (GenBuses,(:>))
import ConCat.Syntactic (Syn,render)
import ConCat.RunCircuit (run)

type EC = Syn :**: (:>)

runU2 :: U2 a b -> IO ()
runU2 = print
{-# INLINE runU2 #-}


type GO a b = (GenBuses a, Ok2 (:>) a b)

runSyn :: Syn a b -> IO ()
runSyn syn = putStrLn ('\n' : render syn)
{-# INLINE runSyn #-}

runSynCirc :: GO a b => String -> EC a b -> IO ()
runSynCirc nm (syn :**: circ) = runSyn syn >> runCirc nm circ
{-# INLINE runSynCirc #-}

runCirc :: GO a b => String -> (a :> b) -> IO ()
runCirc nm circ = run nm [] circ
{-# INLINE runCirc #-}


add5 :: Double -> Double
add5 x = x + 5

decide :: Int -> Bool
decide 4 = True
decide _ = False

fix :: (a -> a) -> a
fix f = let {x = f x} in x

fac :: Int -> Int
fac 1 = 1
fac n = n*fac(n-1)

main :: IO ()
--main = print "hello world!"

main = sequence_ [
   putChar '\n' -- return ()

--  -- Circuit graphs
  , runSynCirc "add"         $ toCcc $ (+) @Double
  , runSynCirc "add5"        $ toCcc add5
  , runSynCirc "add-uncurry" $ toCcc $ uncurry ((+) @Double)
  , runSynCirc "decide"      $ toCcc $ decide
--  , runSynCirc "fac"         $ toCcc (fix (\rec n -> if n == 0 then 1 else n * rec (n-1)) :: Int -> Int)

--  , runSynCirc "fac"         $ toCcc $ fac
--  , runSynCirc "dup"         $ toCcc $ A.dup @(->) @Int
--  , runSynCirc "fst"         $ toCcc $ fst @R @R
--  , runSynCirc "twice"       $ toCcc $ twice @R
--  , runSynCirc "sqr"         $ toCcc $ sqr @R
--  , runSynCirc "complex-mul" $ toCcc $ uncurry ((*) @C)
--  , runSynCirc "magSqr"      $ toCcc $ magSqr @R
--  , runSynCirc "cosSinProd"  $ toCcc $ cosSinProd @R
--  , runSynCirc "xp3y"        $ toCcc $ \ (x,y) -> x + 3 * y :: R
--  , runSynCirc "horner"      $ toCcc $ horner @R [1,3,5]
--  , runSynCirc "cos-2xx"     $ toCcc $ \ x -> cos (2 * x * x) :: R
--
  ]

