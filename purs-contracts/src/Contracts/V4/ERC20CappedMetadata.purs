--------------------------------------------------------------------------------
-- | ERC20CappedMetadata
--------------------------------------------------------------------------------

module Contracts.V4.ERC20CappedMetadata where

import Prelude 

import Data.Either (Either)
import Data.Functor.Tagged (Tagged, tagged)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Data.Lens ((.~))
import Data.Maybe (Maybe(..), fromJust)
import Data.Newtype (class Newtype)
import Data.Symbol (SProxy)
import Network.Ethereum.Web3 (_address, _topics, call, class EventFilter, deployContract, sendTx)
import Network.Ethereum.Web3.Contract.Internal (uncurryFields)
import Network.Ethereum.Web3.Solidity (D2, D5, D6, D8, DOne, Tuple0(..), Tuple1(..), Tuple2(..), Tuple3(..), Tuple5(..), UIntN, class IndexedEvent, unTuple1)
import Network.Ethereum.Web3.Solidity.Size (type (:&))
import Network.Ethereum.Web3.Types (Address, CallError, ChainCursor, HexString, NoPay, TransactionOptions, Web3, defaultFilter, mkHexString)
import Partial.Unsafe (unsafePartial)
--------------------------------------------------------------------------------
-- | ConstructorFn
--------------------------------------------------------------------------------


type ConstructorFn = Tagged (SProxy "constructor(string,string,uint8,string,uint256)") (Tuple5 (Tagged (SProxy "name") String) (Tagged (SProxy "symbol") String) (Tagged (SProxy "decimals") (UIntN (DOne D8))) (Tagged (SProxy "uri") String) (Tagged (SProxy "cap") (UIntN (D2 :& D5 :& DOne D6))))

constructor :: TransactionOptions NoPay -> HexString -> { name :: String, symbol :: String, decimals :: (UIntN (DOne D8)), uri :: String, cap :: (UIntN (D2 :& D5 :& DOne D6)) } -> Web3 HexString
constructor x0 bc r = uncurryFields  r $ constructor' x0 bc
   where
    constructor' :: TransactionOptions NoPay -> HexString -> (Tagged (SProxy "name") String) -> (Tagged (SProxy "symbol") String) -> (Tagged (SProxy "decimals") (UIntN (DOne D8))) -> (Tagged (SProxy "uri") String) -> (Tagged (SProxy "cap") (UIntN (D2 :& D5 :& DOne D6))) -> Web3 HexString
    constructor' y0 bc' y2 y3 y4 y5 y6 = deployContract y0 bc' ((tagged $ Tuple5 y2 y3 y4 y5 y6) :: ConstructorFn)

--------------------------------------------------------------------------------
-- | TokenURIUpdated
--------------------------------------------------------------------------------


newtype TokenURIUpdated = TokenURIUpdated {tokenURI :: String}

derive instance newtypeTokenURIUpdated :: Newtype TokenURIUpdated _

instance eventFilterTokenURIUpdated :: EventFilter TokenURIUpdated where
  eventFilter _ addr = defaultFilter
    # _address .~ Just addr
    # _topics .~ Just [Just ( unsafePartial $ fromJust $ mkHexString "3d25540fafb277423a5c9552c25096f7c0c69178c044fd61c947046f08fb09ca"),Nothing]

instance indexedEventTokenURIUpdated :: IndexedEvent (Tuple1 (Tagged (SProxy "tokenURI") String)) (Tuple0 ) TokenURIUpdated where
  isAnonymous _ = false

derive instance genericTokenURIUpdated :: Generic TokenURIUpdated _

instance eventGenericTokenURIUpdatedShow :: Show TokenURIUpdated where
  show = genericShow

instance eventGenericTokenURIUpdatedeq :: Eq TokenURIUpdated where
  eq = genericEq

--------------------------------------------------------------------------------
-- | OwnershipTransferred
--------------------------------------------------------------------------------


newtype OwnershipTransferred = OwnershipTransferred {previousOwner :: Address,newOwner :: Address}

derive instance newtypeOwnershipTransferred :: Newtype OwnershipTransferred _

instance eventFilterOwnershipTransferred :: EventFilter OwnershipTransferred where
  eventFilter _ addr = defaultFilter
    # _address .~ Just addr
    # _topics .~ Just [Just ( unsafePartial $ fromJust $ mkHexString "8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0"),Nothing,Nothing]

instance indexedEventOwnershipTransferred :: IndexedEvent (Tuple2 (Tagged (SProxy "previousOwner") Address) (Tagged (SProxy "newOwner") Address)) (Tuple0 ) OwnershipTransferred where
  isAnonymous _ = false

derive instance genericOwnershipTransferred :: Generic OwnershipTransferred _

instance eventGenericOwnershipTransferredShow :: Show OwnershipTransferred where
  show = genericShow

instance eventGenericOwnershipTransferredeq :: Eq OwnershipTransferred where
  eq = genericEq

--------------------------------------------------------------------------------
-- | MinterAdded
--------------------------------------------------------------------------------


newtype MinterAdded = MinterAdded {account :: Address}

derive instance newtypeMinterAdded :: Newtype MinterAdded _

instance eventFilterMinterAdded :: EventFilter MinterAdded where
  eventFilter _ addr = defaultFilter
    # _address .~ Just addr
    # _topics .~ Just [Just ( unsafePartial $ fromJust $ mkHexString "6ae172837ea30b801fbfcdd4108aa1d5bf8ff775444fd70256b44e6bf3dfc3f6"),Nothing]

instance indexedEventMinterAdded :: IndexedEvent (Tuple1 (Tagged (SProxy "account") Address)) (Tuple0 ) MinterAdded where
  isAnonymous _ = false

derive instance genericMinterAdded :: Generic MinterAdded _

instance eventGenericMinterAddedShow :: Show MinterAdded where
  show = genericShow

instance eventGenericMinterAddedeq :: Eq MinterAdded where
  eq = genericEq

--------------------------------------------------------------------------------
-- | MinterRemoved
--------------------------------------------------------------------------------


newtype MinterRemoved = MinterRemoved {account :: Address}

derive instance newtypeMinterRemoved :: Newtype MinterRemoved _

instance eventFilterMinterRemoved :: EventFilter MinterRemoved where
  eventFilter _ addr = defaultFilter
    # _address .~ Just addr
    # _topics .~ Just [Just ( unsafePartial $ fromJust $ mkHexString "e94479a9f7e1952cc78f2d6baab678adc1b772d936c6583def489e524cb66692"),Nothing]

instance indexedEventMinterRemoved :: IndexedEvent (Tuple1 (Tagged (SProxy "account") Address)) (Tuple0 ) MinterRemoved where
  isAnonymous _ = false

derive instance genericMinterRemoved :: Generic MinterRemoved _

instance eventGenericMinterRemovedShow :: Show MinterRemoved where
  show = genericShow

instance eventGenericMinterRemovedeq :: Eq MinterRemoved where
  eq = genericEq

--------------------------------------------------------------------------------
-- | Transfer
--------------------------------------------------------------------------------


newtype Transfer = Transfer {from :: Address,to :: Address,value :: (UIntN (D2 :& D5 :& DOne D6))}

derive instance newtypeTransfer :: Newtype Transfer _

instance eventFilterTransfer :: EventFilter Transfer where
  eventFilter _ addr = defaultFilter
    # _address .~ Just addr
    # _topics .~ Just [Just ( unsafePartial $ fromJust $ mkHexString "ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"),Nothing,Nothing]

instance indexedEventTransfer :: IndexedEvent (Tuple2 (Tagged (SProxy "from") Address) (Tagged (SProxy "to") Address)) (Tuple1 (Tagged (SProxy "value") (UIntN (D2 :& D5 :& DOne D6)))) Transfer where
  isAnonymous _ = false

derive instance genericTransfer :: Generic Transfer _

instance eventGenericTransferShow :: Show Transfer where
  show = genericShow

instance eventGenericTransfereq :: Eq Transfer where
  eq = genericEq

--------------------------------------------------------------------------------
-- | Approval
--------------------------------------------------------------------------------


newtype Approval = Approval {owner :: Address,spender :: Address,value :: (UIntN (D2 :& D5 :& DOne D6))}

derive instance newtypeApproval :: Newtype Approval _

instance eventFilterApproval :: EventFilter Approval where
  eventFilter _ addr = defaultFilter
    # _address .~ Just addr
    # _topics .~ Just [Just ( unsafePartial $ fromJust $ mkHexString "8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925"),Nothing,Nothing]

instance indexedEventApproval :: IndexedEvent (Tuple2 (Tagged (SProxy "owner") Address) (Tagged (SProxy "spender") Address)) (Tuple1 (Tagged (SProxy "value") (UIntN (D2 :& D5 :& DOne D6)))) Approval where
  isAnonymous _ = false

derive instance genericApproval :: Generic Approval _

instance eventGenericApprovalShow :: Show Approval where
  show = genericShow

instance eventGenericApprovaleq :: Eq Approval where
  eq = genericEq

--------------------------------------------------------------------------------
-- | AddMinterFn
--------------------------------------------------------------------------------


type AddMinterFn = Tagged (SProxy "addMinter(address)") (Tuple1 (Tagged (SProxy "account") Address))

addMinter :: TransactionOptions NoPay -> { account :: Address } -> Web3 HexString
addMinter x0 r = uncurryFields  r $ addMinter' x0
   where
    addMinter' :: TransactionOptions NoPay -> (Tagged (SProxy "account") Address) -> Web3 HexString
    addMinter' y0 y1 = sendTx y0 ((tagged $ Tuple1 y1) :: AddMinterFn)

--------------------------------------------------------------------------------
-- | AllowanceFn
--------------------------------------------------------------------------------


type AllowanceFn = Tagged (SProxy "allowance(address,address)") (Tuple2 (Tagged (SProxy "owner") Address) (Tagged (SProxy "spender") Address))

allowance :: TransactionOptions NoPay -> ChainCursor -> { owner :: Address, spender :: Address } -> Web3 (Either CallError (UIntN (D2 :& D5 :& DOne D6)))
allowance x0 cm r = uncurryFields  r $ allowance' x0 cm
   where
    allowance' :: TransactionOptions NoPay -> ChainCursor -> (Tagged (SProxy "owner") Address) -> (Tagged (SProxy "spender") Address) -> Web3 (Either CallError (UIntN (D2 :& D5 :& DOne D6)))
    allowance' y0 cm' y2 y3 = map unTuple1 <$> call y0 cm' ((tagged $ Tuple2 y2 y3) :: AllowanceFn)

--------------------------------------------------------------------------------
-- | ApproveFn
--------------------------------------------------------------------------------


type ApproveFn = Tagged (SProxy "approve(address,uint256)") (Tuple2 (Tagged (SProxy "spender") Address) (Tagged (SProxy "value") (UIntN (D2 :& D5 :& DOne D6))))

approve :: TransactionOptions NoPay -> { spender :: Address, value :: (UIntN (D2 :& D5 :& DOne D6)) } -> Web3 HexString
approve x0 r = uncurryFields  r $ approve' x0
   where
    approve' :: TransactionOptions NoPay -> (Tagged (SProxy "spender") Address) -> (Tagged (SProxy "value") (UIntN (D2 :& D5 :& DOne D6))) -> Web3 HexString
    approve' y0 y1 y2 = sendTx y0 ((tagged $ Tuple2 y1 y2) :: ApproveFn)

--------------------------------------------------------------------------------
-- | BalanceOfFn
--------------------------------------------------------------------------------


type BalanceOfFn = Tagged (SProxy "balanceOf(address)") (Tuple1 (Tagged (SProxy "owner") Address))

balanceOf :: TransactionOptions NoPay -> ChainCursor -> { owner :: Address } -> Web3 (Either CallError (UIntN (D2 :& D5 :& DOne D6)))
balanceOf x0 cm r = uncurryFields  r $ balanceOf' x0 cm
   where
    balanceOf' :: TransactionOptions NoPay -> ChainCursor -> (Tagged (SProxy "owner") Address) -> Web3 (Either CallError (UIntN (D2 :& D5 :& DOne D6)))
    balanceOf' y0 cm' y2 = map unTuple1 <$> call y0 cm' ((tagged $ Tuple1 y2) :: BalanceOfFn)

--------------------------------------------------------------------------------
-- | CapFn
--------------------------------------------------------------------------------


type CapFn = Tagged (SProxy "cap()") (Tuple0 )

cap :: TransactionOptions NoPay -> ChainCursor -> Web3 (Either CallError (UIntN (D2 :& D5 :& DOne D6)))
cap x0 cm = map unTuple1 <$> call x0 cm ((tagged $ Tuple0 ) :: CapFn)

--------------------------------------------------------------------------------
-- | DecimalsFn
--------------------------------------------------------------------------------


type DecimalsFn = Tagged (SProxy "decimals()") (Tuple0 )

decimals :: TransactionOptions NoPay -> ChainCursor -> Web3 (Either CallError (UIntN (DOne D8)))
decimals x0 cm = map unTuple1 <$> call x0 cm ((tagged $ Tuple0 ) :: DecimalsFn)

--------------------------------------------------------------------------------
-- | DecreaseAllowanceFn
--------------------------------------------------------------------------------


type DecreaseAllowanceFn = Tagged (SProxy "decreaseAllowance(address,uint256)") (Tuple2 (Tagged (SProxy "spender") Address) (Tagged (SProxy "subtractedValue") (UIntN (D2 :& D5 :& DOne D6))))

decreaseAllowance :: TransactionOptions NoPay -> { spender :: Address, subtractedValue :: (UIntN (D2 :& D5 :& DOne D6)) } -> Web3 HexString
decreaseAllowance x0 r = uncurryFields  r $ decreaseAllowance' x0
   where
    decreaseAllowance' :: TransactionOptions NoPay -> (Tagged (SProxy "spender") Address) -> (Tagged (SProxy "subtractedValue") (UIntN (D2 :& D5 :& DOne D6))) -> Web3 HexString
    decreaseAllowance' y0 y1 y2 = sendTx y0 ((tagged $ Tuple2 y1 y2) :: DecreaseAllowanceFn)

--------------------------------------------------------------------------------
-- | IncreaseAllowanceFn
--------------------------------------------------------------------------------


type IncreaseAllowanceFn = Tagged (SProxy "increaseAllowance(address,uint256)") (Tuple2 (Tagged (SProxy "spender") Address) (Tagged (SProxy "addedValue") (UIntN (D2 :& D5 :& DOne D6))))

increaseAllowance :: TransactionOptions NoPay -> { spender :: Address, addedValue :: (UIntN (D2 :& D5 :& DOne D6)) } -> Web3 HexString
increaseAllowance x0 r = uncurryFields  r $ increaseAllowance' x0
   where
    increaseAllowance' :: TransactionOptions NoPay -> (Tagged (SProxy "spender") Address) -> (Tagged (SProxy "addedValue") (UIntN (D2 :& D5 :& DOne D6))) -> Web3 HexString
    increaseAllowance' y0 y1 y2 = sendTx y0 ((tagged $ Tuple2 y1 y2) :: IncreaseAllowanceFn)

--------------------------------------------------------------------------------
-- | IsMinterFn
--------------------------------------------------------------------------------


type IsMinterFn = Tagged (SProxy "isMinter(address)") (Tuple1 (Tagged (SProxy "account") Address))

isMinter :: TransactionOptions NoPay -> ChainCursor -> { account :: Address } -> Web3 (Either CallError Boolean)
isMinter x0 cm r = uncurryFields  r $ isMinter' x0 cm
   where
    isMinter' :: TransactionOptions NoPay -> ChainCursor -> (Tagged (SProxy "account") Address) -> Web3 (Either CallError Boolean)
    isMinter' y0 cm' y2 = map unTuple1 <$> call y0 cm' ((tagged $ Tuple1 y2) :: IsMinterFn)

--------------------------------------------------------------------------------
-- | IsOwnerFn
--------------------------------------------------------------------------------


type IsOwnerFn = Tagged (SProxy "isOwner()") (Tuple0 )

isOwner :: TransactionOptions NoPay -> ChainCursor -> Web3 (Either CallError Boolean)
isOwner x0 cm = map unTuple1 <$> call x0 cm ((tagged $ Tuple0 ) :: IsOwnerFn)

--------------------------------------------------------------------------------
-- | MintFn
--------------------------------------------------------------------------------


type MintFn = Tagged (SProxy "mint(address,uint256)") (Tuple2 (Tagged (SProxy "to") Address) (Tagged (SProxy "value") (UIntN (D2 :& D5 :& DOne D6))))

mint :: TransactionOptions NoPay -> { to :: Address, value :: (UIntN (D2 :& D5 :& DOne D6)) } -> Web3 HexString
mint x0 r = uncurryFields  r $ mint' x0
   where
    mint' :: TransactionOptions NoPay -> (Tagged (SProxy "to") Address) -> (Tagged (SProxy "value") (UIntN (D2 :& D5 :& DOne D6))) -> Web3 HexString
    mint' y0 y1 y2 = sendTx y0 ((tagged $ Tuple2 y1 y2) :: MintFn)

--------------------------------------------------------------------------------
-- | NameFn
--------------------------------------------------------------------------------


type NameFn = Tagged (SProxy "name()") (Tuple0 )

name :: TransactionOptions NoPay -> ChainCursor -> Web3 (Either CallError String)
name x0 cm = map unTuple1 <$> call x0 cm ((tagged $ Tuple0 ) :: NameFn)

--------------------------------------------------------------------------------
-- | OwnerFn
--------------------------------------------------------------------------------


type OwnerFn = Tagged (SProxy "owner()") (Tuple0 )

owner :: TransactionOptions NoPay -> ChainCursor -> Web3 (Either CallError Address)
owner x0 cm = map unTuple1 <$> call x0 cm ((tagged $ Tuple0 ) :: OwnerFn)

--------------------------------------------------------------------------------
-- | RenounceMinterFn
--------------------------------------------------------------------------------


type RenounceMinterFn = Tagged (SProxy "renounceMinter()") (Tuple0 )

renounceMinter :: TransactionOptions NoPay -> Web3 HexString
renounceMinter x0 = sendTx x0 ((tagged $ Tuple0 ) :: RenounceMinterFn)

--------------------------------------------------------------------------------
-- | RenounceOwnershipFn
--------------------------------------------------------------------------------


type RenounceOwnershipFn = Tagged (SProxy "renounceOwnership()") (Tuple0 )

renounceOwnership :: TransactionOptions NoPay -> Web3 HexString
renounceOwnership x0 = sendTx x0 ((tagged $ Tuple0 ) :: RenounceOwnershipFn)

--------------------------------------------------------------------------------
-- | SymbolFn
--------------------------------------------------------------------------------


type SymbolFn = Tagged (SProxy "symbol()") (Tuple0 )

symbol :: TransactionOptions NoPay -> ChainCursor -> Web3 (Either CallError String)
symbol x0 cm = map unTuple1 <$> call x0 cm ((tagged $ Tuple0 ) :: SymbolFn)

--------------------------------------------------------------------------------
-- | TokenURIFn
--------------------------------------------------------------------------------


type TokenURIFn = Tagged (SProxy "tokenURI()") (Tuple0 )

tokenURI :: TransactionOptions NoPay -> ChainCursor -> Web3 (Either CallError String)
tokenURI x0 cm = map unTuple1 <$> call x0 cm ((tagged $ Tuple0 ) :: TokenURIFn)

--------------------------------------------------------------------------------
-- | TotalSupplyFn
--------------------------------------------------------------------------------


type TotalSupplyFn = Tagged (SProxy "totalSupply()") (Tuple0 )

totalSupply :: TransactionOptions NoPay -> ChainCursor -> Web3 (Either CallError (UIntN (D2 :& D5 :& DOne D6)))
totalSupply x0 cm = map unTuple1 <$> call x0 cm ((tagged $ Tuple0 ) :: TotalSupplyFn)

--------------------------------------------------------------------------------
-- | TransferFn
--------------------------------------------------------------------------------


type TransferFn = Tagged (SProxy "transfer(address,uint256)") (Tuple2 (Tagged (SProxy "to") Address) (Tagged (SProxy "value") (UIntN (D2 :& D5 :& DOne D6))))

transfer :: TransactionOptions NoPay -> { to :: Address, value :: (UIntN (D2 :& D5 :& DOne D6)) } -> Web3 HexString
transfer x0 r = uncurryFields  r $ transfer' x0
   where
    transfer' :: TransactionOptions NoPay -> (Tagged (SProxy "to") Address) -> (Tagged (SProxy "value") (UIntN (D2 :& D5 :& DOne D6))) -> Web3 HexString
    transfer' y0 y1 y2 = sendTx y0 ((tagged $ Tuple2 y1 y2) :: TransferFn)

--------------------------------------------------------------------------------
-- | TransferFromFn
--------------------------------------------------------------------------------


type TransferFromFn = Tagged (SProxy "transferFrom(address,address,uint256)") (Tuple3 (Tagged (SProxy "from") Address) (Tagged (SProxy "to") Address) (Tagged (SProxy "value") (UIntN (D2 :& D5 :& DOne D6))))

transferFrom :: TransactionOptions NoPay -> { from :: Address, to :: Address, value :: (UIntN (D2 :& D5 :& DOne D6)) } -> Web3 HexString
transferFrom x0 r = uncurryFields  r $ transferFrom' x0
   where
    transferFrom' :: TransactionOptions NoPay -> (Tagged (SProxy "from") Address) -> (Tagged (SProxy "to") Address) -> (Tagged (SProxy "value") (UIntN (D2 :& D5 :& DOne D6))) -> Web3 HexString
    transferFrom' y0 y1 y2 y3 = sendTx y0 ((tagged $ Tuple3 y1 y2 y3) :: TransferFromFn)

--------------------------------------------------------------------------------
-- | TransferOwnershipFn
--------------------------------------------------------------------------------


type TransferOwnershipFn = Tagged (SProxy "transferOwnership(address)") (Tuple1 (Tagged (SProxy "newOwner") Address))

transferOwnership :: TransactionOptions NoPay -> { newOwner :: Address } -> Web3 HexString
transferOwnership x0 r = uncurryFields  r $ transferOwnership' x0
   where
    transferOwnership' :: TransactionOptions NoPay -> (Tagged (SProxy "newOwner") Address) -> Web3 HexString
    transferOwnership' y0 y1 = sendTx y0 ((tagged $ Tuple1 y1) :: TransferOwnershipFn)

--------------------------------------------------------------------------------
-- | UpdateTokenURIFn
--------------------------------------------------------------------------------


type UpdateTokenURIFn = Tagged (SProxy "updateTokenURI(string)") (Tuple1 (Tagged (SProxy "uri") String))

updateTokenURI :: TransactionOptions NoPay -> { uri :: String } -> Web3 HexString
updateTokenURI x0 r = uncurryFields  r $ updateTokenURI' x0
   where
    updateTokenURI' :: TransactionOptions NoPay -> (Tagged (SProxy "uri") String) -> Web3 HexString
    updateTokenURI' y0 y1 = sendTx y0 ((tagged $ Tuple1 y1) :: UpdateTokenURIFn)