{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}

module Pixura.Contracts.SuperRareMarketAuction where

import           Network.Ethereum.Contract.TH

[abiFrom|../contracts/build/contracts/SuperRareMarketAuction.json|]
