{-# LANGUAGE TemplateHaskell #-}

import MagicCP
import CF.CFConfig
import Text.Printf
import MagicHaskeller
import MagicHaskeller.LibTH

import MagicCP.SearchOptions
import           Control.Concurrent             ( threadDelay )
import           System.Mem                     ( performGC )
import           Data.Char

testsolve wOps wAbs wOC cfg pId lib = do
  printf "\n##############################\n%s %s\n" (show wOps) (show wAbs)
  me <- solveWithAllParsers wOps wAbs wOC cfg lib pId
  case me of
    Just e -> putStrLn $ pprintUC e
    Nothing -> do
      putStrLn "sad"
      performGC

main = do
  putStrLn "please (ContestId, problemLetter)"
  --pId <- read <$> getLine :: IO (Int, Char)
  cfg <- getCFConfig
  --testsolve WithOptimizations WithoutAbsents WithoutOutputConstants cfg (59, 'a') lib59a
  --testsolve WithOptimizations WithAbsents WithoutOutputConstants cfg (59, 'a') lib59a
  --testsolve WithoutOptimizations WithoutAbsents WithoutOutputConstants cfg (59, 'a') lib59a
  --testsolve WithoutOptimizations WithAbsents WithoutOutputConstants cfg (59, 'a') lib59a

  --testsolve WithOptimizations WithoutAbsents WithoutOutputConstants cfg (822, 'a') lib822a
  --testsolve WithOptimizations WithAbsents WithoutOutputConstants cfg (822, 'a') lib822a
  --testsolve WithoutOptimizations WithoutAbsents WithoutOutputConstants cfg (822, 'a') lib822a
  --testsolve WithoutOptimizations WithAbsents WithoutOutputConstants cfg (822, 'a') lib822a

  --testsolve WithOptimizations WithoutAbsents WithOutputConstants cfg (1186, 'a') lib1186a
  --testsolve WithOptimizations WithAbsents WithOutputConstants cfg (1186, 'a') lib1186a
  --testsolve WithoutOptimizations WithoutAbsents WithOutputConstants cfg (1186, 'a') lib1186a
  --testsolve WithoutOptimizations WithAbsents WithOutputConstants cfg (1186, 'a') lib1186a
  --testsolve WithOptimizations WithoutAbsents WithOutputConstants cfg (1186, 'a') lib1186a'
  --testsolve WithOptimizations WithAbsents WithOutputConstants cfg (1186, 'a') lib1186a'
  --testsolve WithoutOptimizations WithoutAbsents WithOutputConstants cfg (1186, 'a') lib1186a'
  --testsolve WithoutOptimizations WithAbsents WithOutputConstants cfg (1186, 'a') lib1186a'

  --testsolve WithOptimizations WithoutAbsents WithOutputConstants cfg (110, 'a') lib110a'
  --testsolve WithOptimizations WithAbsents WithOutputConstants cfg (110, 'a') lib110a'
  testsolve WithoutOptimizations WithoutAbsents WithOutputConstants cfg (110, 'a') lib110a'
  testsolve WithoutOptimizations WithAbsents WithOutputConstants cfg (110, 'a') lib110a'


  --testsolve WithOptimizations WithoutAbsents WithOutputConstants cfg (1257, 'a') lib1257a
  --testsolve WithOptimizations WithAbsents WithOutputConstants cfg (1257, 'a') lib1257a
  --testsolve WithoutOptimizations WithoutAbsents WithOutputConstants cfg (1257, 'a') lib1257a
  --testsolve WithoutOptimizations WithAbsents WithOutputConstants cfg (1257, 'a') lib1257a


  --testsolve WithOptimizations WithoutAbsents WithoutOutputConstants cfg pId lib705a'
  --testsolve WithOptimizations WithAbsents WithoutOutputConstants cfg pId lib705a'
  --testsolve WithoutOptimizations WithoutAbsents WithoutOutputConstants cfg pId lib705a'
  --testsolve WithoutOptimizations WithAbsents WithoutOutputConstants cfg pId lib705a'

andP, orP, iFP :: [PrimitiveWithOpt]
foldP, listParaP :: [PrimitiveWithOpt]
greaterOrEqP, plusOneP, isEvenP, minusOneP, minusP, minP :: [PrimitiveWithOpt]
absP, eqIntP, zeroP :: [PrimitiveWithOpt]
eqCharP :: [PrimitiveWithOpt]
andP = $(pOptSingle [|
  ((&&) :: Bool -> Bool -> Bool, [ NotConstantAsFirstArg
                                 , NotConstantAsSecondArg
                                 , CommAndAssoc
                                 , FirstAndSecondArgDifferent ])
        |])
orP = $(pOptSingle [|
  ((||) :: Bool -> Bool -> Bool, [ NotConstantAsFirstArg
                                 , NotConstantAsSecondArg
                                 , CommAndAssoc
                                 , FirstAndSecondArgDifferent ])
        |])
iFP = $(pOptSingle [|
  (iF :: Bool -> a -> a -> a, [ NotConstantAsFirstArg
                              , SecondAndThirdArgDifferent ])
        |])


foldP = $(pOptSingle [|
  ((foldl :: (a -> b -> a) -> a -> [b] -> a), [ FirstArgOfFirstArgUsed
                                              , SecondArgOfFirstArgUsed ])
        |])
listParaP = $(pOptSingle [|
  (list_para :: (->) [b] (a -> (b -> [b] -> a -> a) -> a), [NotConstantAsFirstArg
                                                           , ThirdArgOfThirdArgUsed])
        |])
headIntP = $(pOptSingle [|
  (hd :: [Int] -> Int, [NotConstantAsFirstArg])
        |])
headCharP = $(pOptSingle [|
  (hd :: [Char] -> Char, [NotConstantAsFirstArg])
        |])
tailCharP = $(pOptSingle [|
  (tail :: [Char] -> [Char], [NotConstantAsFirstArg])
        |])
concatCharP = $(pOptSingle [|
  ((:) :: Char -> [Char] -> [Char], [NotConstantAsFirstArg])
        |])
headP = $(pOptSingle [|
  (hd :: [a] -> a, [NotConstantAsFirstArg])
        |])
tailP = $(pOptSingle [|
  (tail :: [a] -> [a], [NotConstantAsFirstArg])
        |])
concatP = $(pOptSingle [|
  ((:) :: a -> [a] -> [a], [NotConstantAsFirstArg, NotConstantAsSecondArg])
        |])
emptyListP = $(pOptSingle [|
  ([] :: [a], [])
        |])
joinCharP = $(pOptSingle [|
  ((++) :: [Char] -> [Char] -> [Char], [NotConstantAsFirstArg, NotConstantAsSecondArg])
        |])


greaterOrEqP = $(pOptSingle [|
  ((>=) :: Int -> Int -> Bool, [ FirstAndSecondArgDifferent ])
        |])
plusOneP = $(pOptSingle [|
  ((1+) :: Int->Int, [])
        |])
plusP = $(pOptSingle [|
  ((+) :: (->) Int ((->) Int Int), [CommAndAssoc])
        |])
productP = $(pOptSingle [|
  ((*) :: (->) Int ((->) Int Int), [CommAndAssoc])
        |])
isEvenP = $(pOptSingle [|
  (((== 0) . (`mod` 2)) :: Int -> Bool, [ NotConstantAsFirstArg ])
        |])
minusOneP = $(pOptSingle [|
  ((flip (-) 1) :: Int->Int, [ NotConstantAsFirstArg ])
        |])
minusP = $(pOptSingle [|
  ((-) :: Int -> Int -> Int, [ NotConstantAsFirstArg, NotConstantAsSecondArg ])
        |])
minP = $(pOptSingle [|
  ((min) :: Int -> Int -> Int, [ NotConstantAsFirstArg, NotConstantAsSecondArg ])
        |])
absP = $(pOptSingle [|
  ((abs) :: Int -> Int, [ NotConstantAsFirstArg ])
        |])
eqIntP = $(pOptSingle [|
  ((==) :: Int -> Int -> Bool, [ CommAndAssoc
                               , FirstAndSecondArgDifferent ])
        |])
zeroP = $(pOptSingle [|
  (0 :: Int, [])
        |])
oneP = $(pOptSingle [|
  (1 :: Int, [])
        |])
natParaP = $(pOptSingle [|
  (nat_para :: (->) Int (a -> (Int -> a -> a) -> a), [NotConstantAsFirstArg, SecondArgOfThirdArgUsed])
        |])
gcdP = $(pOptSingle [|
  ((gcd) :: Int -> Int -> Int, [ NotConstantAsFirstArg, NotConstantAsSecondArg ])
        |])


eqCharP = $(pOptSingle [|
  ((==) :: Char -> Char -> Bool, [ CommAndAssoc
                                 , FirstAndSecondArgDifferent ])
        |])
lib1257a :: [PrimitiveWithOpt]
lib1257a = minusOneP ++ minusP ++ absP ++ minP ++ plusP

lib1030a, lib1030a' :: [PrimitiveWithOpt]
lib1030a = foldP ++ headIntP ++ eqIntP ++ zeroP ++ plusOneP ++ iFP
lib1030a' = listParaP ++ headIntP ++ eqIntP ++ zeroP ++ plusOneP ++ iFP

lib1186a, lib1186a' :: [PrimitiveWithOpt]
lib1186a = iFP ++ greaterOrEqP ++ andP
lib1186a' = iFP ++ greaterOrEqP

lib705a, lib705a' :: [PrimitiveWithOpt]
lib705a = isEvenP ++ iFP ++ minusOneP ++ minusP ++ natParaP ++
  $(pOpt [|
  ( ((\n -> iF ((n `mod` 2) == 0) "I love it" "I hate it") :: Int -> [Char] , [NotConstantAsFirstArg])
  , (("I hate that " ++) :: [Char] -> [Char], [NotConstantAsFirstArg])
  , (("I love that " ++) :: [Char] -> [Char], [NotConstantAsFirstArg])
  )|])
lib705a' = isEvenP ++ iFP ++ minusOneP ++ minusP ++ natParaP ++
  $(pOpt [| (
    ("I love it" :: [Char], [])
  , ("I hate it" :: [Char], [])
  , (("I hate that " ++) :: [Char] -> [Char], [NotConstantAsFirstArg])
  , (("I love that " ++) :: [Char] -> [Char], [NotConstantAsFirstArg])
  )|])

lib959a :: [PrimitiveWithOpt]
lib959a = isEvenP ++ iFP

lib1257b, lib1257b' :: [PrimitiveWithOpt]
lib1257b = greaterOrEqP ++ iFP ++
  $(pOpt [| (
    (1 :: Int, [])
  , (3 :: Int, [])
  )|])
lib1257b' = greaterOrEqP ++ iFP ++ zeroP ++ plusOneP ++
  $(pOptSingle [|
    (3 :: Int, [])
  |])

lib110a, lib110a' :: [PrimitiveWithOpt]
lib110a = eqCharP ++ foldP ++ iFP ++ orP ++
  $(pOpt [| (
    ((== '4') :: Char -> Bool, [])
  , ((== '7') :: Char -> Bool, [])
  , (show . (length . filter (\x -> (x == '4') || (x == '7'))) :: [Char] -> [Char], [])
  )|])
lib110a' = eqCharP ++ foldP ++ iFP ++ orP ++
  $(pOpt [| (
    ('4' :: Char, [])
  , ('7' :: Char, [])
  , (show . (length . filter (\x -> (x == '4') || (x == '7'))) :: [Char] -> [Char], [])
  --, ((\f x -> show $ (length . filter f) x) :: (Char -> Bool) -> [Char] -> [Char], [])
  )|])

lib281a, lib281a' :: [PrimitiveWithOpt]
lib281a = headCharP ++ tailCharP ++ concatCharP ++
  $(pOptSingle [|
    (toUpper :: Char -> Char, [])
  |])
lib281a' = headCharP ++ tailCharP ++ concatCharP ++ emptyListP ++ joinCharP ++
  $(pOptSingle [|
    (toUpper :: Char -> Char, [])
  |])


lib822a :: [PrimitiveWithOpt]
lib822a = minP ++ natParaP ++ oneP ++ productP ++ plusOneP ++ gcdP

lib59a :: [PrimitiveWithOpt]
lib59a = iFP ++ greaterOrEqP ++ emptyListP ++
  $(pOpt [| (
    ((\f -> length . filter f) :: (Char -> Bool) -> [Char] -> Int, [NotConstantAsSecondArg])
  , (isUpper :: Char -> Bool, [])
  , (isLower :: Char -> Bool, [])
  , (toUpper :: Char -> Char, [])
  , (toLower :: Char -> Char, [])
  , (map :: (a -> b) -> [a] -> [b], [NotConstantAsSecondArg, FirstArgOfFirstArgUsed])
  )|])
