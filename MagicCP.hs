{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
module MagicCP where

import qualified Language.Haskell.TH as TH

import Control.Monad( when )
import Data.Array( elems )
import Data.Char( toLower )
import Data.Generics(everywhere, mkT, Data)
import Debug.Trace
import System.FilePath.Posix( (</>) )

import CF
import CF.CFConfig
import CF.CFToolWrapper

import MagicHaskeller hiding ( TH(..) )
import MagicHaskeller.ProgramGenerator
import MagicHaskeller.LibTH( initializeTest )
import MagicHaskeller.LibTHDefinitions

checkInitialized :: IO ()
checkInitialized = do
  pg <- extractCommon <$> getPG
  when (null $ elems (vl pg) ++ elems (pvl pg)) $ putStrLn "ProgramGenerator not initialized."

generateFile :: CFConfig -> ProblemId -> TH.Exp -> IO ()
generateFile CFConfig{..} (cId, pIndex) e = do
  program <- runQ $ concat <$> sequence
    [ allDeclarations
    , (:[]) <$> funD (mkName "solve") [clause [] (normalB $ return e) []]
    , [d| main = getContents >>= \c -> putStrLn (solve c) |]
    ]
  writeFile fileName (pprintUC program)
  where
    fileName = cfparse_dir </> show cId </> [toLower pIndex] </> (toLower pIndex:".hs")

pprintUC :: (Ppr a, Data a) => a -> String
pprintUC =  pprint . everywhere (mkT unqCons)
unqCons :: TH.Name -> TH.Name
unqCons n = mkName (nameBase n)


solvev0 :: ProblemId -> IO Verdict
solvev0 pId = do
  checkInitialized
  cfg <- getCFConfig
  p <- getPredicate cfg pId
  Just exp <- findDo (\e _ -> return (Just e)) True p
  generateFile cfg pId exp
  testVerd <- testSolution cfg pId
  case testVerd of
    Accepted -> submitSolution cfg pId
    r@Rejected{} -> do
      putStrLn "Failed Sample Tests"
      return r
