{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC
    -fno-warn-unused-imports
#-}

{-
  Copyright 2019 The CodeWorld Authors. All rights reserved.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-}
module Model where

import Control.Applicative
import Control.Monad
import Data.Aeson
import Data.Text (Text)
import System.FilePath (FilePath)

data Project = Project
    { projectName :: Text
    , projectSource :: Text
    , projectHistory :: Value
    }

instance FromJSON Project where
    parseJSON (Object v) =
        Project <$> v .: "name" <*> v .: "source" <*> v .: "history"
    parseJSON _ = mzero

instance ToJSON Project where
    toJSON p =
        object
            [ "name" .= projectName p
            , "source" .= projectSource p
            , "history" .= projectHistory p
            ]

data Directory = Directory
    { files :: [Text]
    , dirs :: [Text]
    } deriving (Show)

instance ToJSON Directory where
    toJSON dir = object ["files" .= files dir, "dirs" .= dirs dir]

data CompileResult = CompileResult
    { compileHash :: Text
    , compileDeployHash :: Text
    }

instance ToJSON CompileResult where
    toJSON cr =
        object ["hash" .= compileHash cr, "dhash" .= compileDeployHash cr]

data Gallery = Gallery { galleryItems :: [GalleryItem] }
data GalleryItem = GalleryItem
    { galleryItemName :: Text,
      galleryItemURL :: Text,
      galleryItemCode :: Maybe Text
    }

instance ToJSON Gallery where
    toJSON g = object [ "items" .= galleryItems g ]

instance ToJSON GalleryItem where
    toJSON item = case galleryItemCode item of
        Nothing -> object base
        Just code -> object (("code" .= code) : base)
      where base = [ "name" .= galleryItemName item
                   , "url" .= galleryItemURL item
                   ]
