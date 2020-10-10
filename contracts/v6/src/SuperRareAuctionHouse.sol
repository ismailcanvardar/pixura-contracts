pragma solidity 0.6.12;

import "openzeppelin-solidity-solc6/contracts/token/ERC721/IERC721.sol";
import "openzeppelin-solidity-solc6/contracts/math/SafeMath.sol";
import "openzeppelin-solidity-solc6/contracts/access/Ownable.sol";
import "./IERC721CreatorRoyalty.sol";
import "./IMarketplaceSettings.sol";
import "./Payments.sol";

contract SuperRareAuctionHouse is Ownable, Payments {
    using SafeMath for uint256;

    /////////////////////////////////////////////////////////////////////////
    // Constants
    /////////////////////////////////////////////////////////////////////////
    uint16 constant maxLength = 10000; // TODO: Is this the correct value?

    /////////////////////////////////////////////////////////////////////////
    // Structs
    /////////////////////////////////////////////////////////////////////////
    // A reserve auction.
    struct ReserveAuction {
        address auctionCreator;
        uint16 lengthOfAuction;
        uint256 startedBlock;
        uint256 reservePrice;
    }

    // A scheduled auction.
    struct ScheduledAuction {
        address auctionCreator;
        uint16 lengthOfAuction;
        uint256 startingBlock;
        uint256 minimumBid;
    }

    // The active bid for a given token, contains the bidder, the marketplace fee at the time of the bid, and the amount of wei placed on the token
    struct ActiveBid {
        address payable bidder;
        uint8 marketplaceFee;
        uint256 amount;
    }

    /////////////////////////////////////////////////////////////////////////
    // State Variables
    /////////////////////////////////////////////////////////////////////////
    // Marketplace settings contract
    IMarketplaceSettings public marketSettings;

    // Creator Royalty Interace
    IERC721CreatorRoyalty public iERC721CreatorRoyalty;

    // Mapping from ERC721 contract to mapping of tokenId to Reserve Auctions.
    mapping(address => mapping(uint256 => ReserveAuction))
        private reserveAuctions;

    // Mapping from ERC721 contract to mapping of tokenId to Scheduled Auctions.
    mapping(address => mapping(uint256 => ScheduledAuction))
        private scheduledAuctions;

    // Mapping of ERC721 contract to mapping of token ID to the current bid amount.
    mapping(address => mapping(uint256 => ActiveBid)) private currentBids;

    /////////////////////////////////////////////////////////////////////////
    // Events
    /////////////////////////////////////////////////////////////////////////
    event NewReserveAuction(
        address indexed _contractAddress,
        uint256 indexed _tokenId,
        address indexed _auctionCreator,
        uint256 _reservePrice,
        uint16 _lengthOfAuction
    );

    event CancelReserveAuction(
        address indexed _contractAddress,
        uint256 indexed _tokenId,
        address indexed _auctionCreator,
        uint256 _reservePrice,
        uint16 _lengthOfAuction
    );

    event ReserveAuctionCancelBid(
        address indexed _bidder,
        address indexed _contractAddress,
        uint256 indexed _tokenId,
        uint256 _amount
    );

    event NewScheduledAuction(
        address indexed _contractAddress,
        uint256 indexed _tokenId,
        address indexed _auctionCreator,
        uint256 _startingBlock,
        uint256 _minimumBid,
        uint16 _lengthOfAuction
    );

    /////////////////////////////////////////////////////////////////////////
    // createReserveAuction
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev create a reserve auction token contract address, token id, price
     * Rules:
     * - Cannot create an auction if contract isn't approved by owner
     * - lengthOfAuction (in blocks) > 0
     * - Reserve price must be >= 0
     * - Must be owner of the token
     * - Cannot have a current auction going
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     * @param _reservePrice uint256 Wei value of the reserve price.
     * @param _lengthOfAuction uint16 length of auction in blocks.
     */
    function createReserveAuction(
        address _contractAddress,
        uint256 _tokenId,
        uint256 _reservePrice,
        uint16 _lengthOfAuction
    ) public {
        // Rules
        _requireOwnerApproval(_contractAddress, _tokenId);
        _requireOwnerAsSender(_contractAddress, _tokenId);
        _requireNoCurrentAuction(_contractAddress, _tokenId);
        require(
            _lengthOfAuction > 0,
            "createReserveAuction::_lengthOfAuction must be > 0"
        );
        require(
            _reservePrice >= 0,
            "createReserveAuction::_reservePrice must be >= 0"
        );

        // Create the auction
        reserveAuctions[_contractAddress][_tokenId] = ReserveAuction(
            msg.sender,
            _lengthOfAuction,
            0,
            _reservePrice
        );

        emit NewReserveAuction(
            _contractAddress,
            _tokenId,
            msg.sender,
            _reservePrice,
            _lengthOfAuction
        );
    }

    /////////////////////////////////////////////////////////////////////////
    // cancelReserveAuction
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev cancel a reserve auction with token id
     * Rules:
     * - Must have reserve auction for the token
     * - Auction cannot have started
     * - Must be the creator of the auction
     * - Must return outstanding bid
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     */
    function cancelReserveAuction(address _contractAddress, uint256 _tokenId)
        external
    {
        require(
            _hasReserveAuction(_contractAddress, _tokenId),
            "cancelReserveAuction::must have a reserve auction"
        );
        require(
            reserveAuctions[_contractAddress][_tokenId].startedBlock == 0,
            "cancelReserveAuction::auction cannot be started"
        );
        require(
            reserveAuctions[_contractAddress][_tokenId].auctionCreator ==
                msg.sender,
            "cancelReserveAuction::must be the creator of the auction"
        );

        _cancelReserveAuction(_contractAddress, _tokenId);

        emit CancelReserveAuction(
            _contractAddress,
            _tokenId,
            reserveAuctions[_contractAddress][_tokenId].auctionCreator,
            reserveAuctions[_contractAddress][_tokenId].reservePrice,
            reserveAuctions[_contractAddress][_tokenId].lengthOfAuction
        );
    }

    /////////////////////////////////////////////////////////////////////////
    // cancelBid
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Withdraw a bid
     * Rules:
     * - Auction cannot have started
     * - Must reserve auction
     * - Must have the current bid on the token
     * - Must return outstanding bid
     * - Must be the bidder
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     */
    function cancelBid(address _contractAddress, uint256 _tokenId) external {
        require(
            _hasReserveAuction(_contractAddress, _tokenId),
            "cancelBid::must have a reserve auction"
        );
        require(
            reserveAuctions[_contractAddress][_tokenId].startedBlock == 0,
            "cancelBid::auction cannot be started"
        );
        require(
            currentBids[_contractAddress][_tokenId].bidder == msg.sender,
            "cancelBid::must be the current bidder"
        );

        ActiveBid memory currentBid = currentBids[_contractAddress][_tokenId];

        _refundBid(_contractAddress, _tokenId);

        emit ReserveAuctionCancelBid(
            currentBid.bidder,
            _contractAddress,
            _tokenId,
            currentBid.amount
        );
    }

    /////////////////////////////////////////////////////////////////////////
    // createScheduledAuction
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev create a scheduled auction token contract address, token id
     * Rules:
     * - lengthOfAuction (in blocks) > 0
     * - startingBlock > currentBlock
     * - Cannot create an auction if contract isn't approved by owner
     * - Minimum bid must be >= 0
     * - Must be owner of the token
     * - Cannot have a current auction going for this token
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     * @param _minimumBid uint256 Wei value of the reserve price.
     * @param _lengthOfAuction uint16 length of auction in blocks.
     * @param _startingBlock uint256 block number to start the auction on.
     */
    function createScheduledAuction(
        address _contractAddress,
        uint256 _tokenId,
        uint256 _minimumBid,
        uint16 _lengthOfAuction,
        uint256 _startingBlock
    ) external {
        require(
            _lengthOfAuction > 0,
            "createScheduledAuction::_lengthOfAuction must be greater than 0"
        );
        require(
            _startingBlock > block.number,
            "createScheduledAuction::_startingBlock must be greater than block.number"
        );
        _requireOwnerApproval(_contractAddress, _tokenId);
        _requireOwnerAsSender(_contractAddress, _tokenId);
        _requireNoCurrentAuction(_contractAddress, _tokenId);

        // Create the scheduled auction.
        scheduledAuctions[_contractAddress][_tokenId] = ScheduledAuction(
            msg.sender,
            _lengthOfAuction,
            _startingBlock,
            _minimumBid
        );

        // Transfer the token to this contract to act as escrow.
        IERC721 erc721 = IERC721(_contractAddress);
        erc721.transferFrom(msg.sender, _contractAddress);

        emit 
    }

    /////////////////////////////////////////////////////////////////////////
    // placeBid
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Bid on artwork with price and token id
     * Rules:
     * - There must be a running auction or a reserve price auction for the token
     * - bid > 0
     * - bid >= minimum bid
     * - Auction creator != bidder
     * - bid > current bid
     * - if previous bid then returned
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     * @param _bid uint256 Wei value of the reserve price.
     */
    function placeBid(
        address _contractAddress,
        uint256 _tokenId,
        uint256 _bid
    ) external {
        // Implementation
        // if reserve auction price met, take custody of token
    }

    /////////////////////////////////////////////////////////////////////////
    // settleAuction
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Settles the auction, transferring the auctioned token to the bidder and the bid to auction creator.
     * Rules:
     * - There must be an unsettled auction for the token
     * - current bidder becomes new owner
     * - auction creator gets paid
     * - there is no longer an auction for the token
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     */
    function settleAuction(address _contractAddress, uint256 _tokenId)
        external
    {}

    /////////////////////////////////////////////////////////////////////////
    // getAuctionDetails
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Get current auction details for a token
     * Rules:
     * - Return empty when there's no auction
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     */
    function getAuctionDetails(address _contractAddress, uint256 _tokenId)
        external
    {}

    /////////////////////////////////////////////////////////////////////////
    // _requireOwnerApproval
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Require that the owner have the SuperRareAuctionHouse approved.
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     */
    function _requireOwnerApproval(address _contractAddress, uint256 _tokenId)
        internal
        view
    {
        IERC721 erc721 = IERC721(_contractAddress);
        address owner = erc721.ownerOf(_tokenId);
        require(
            erc721.isApprovedForAll(owner, address(this)),
            "owner must have approved contract"
        );
    }

    /////////////////////////////////////////////////////////////////////////
    // _requireOwnerAsSender
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Require that the owner be the sender.
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     */
    function _requireOwnerAsSender(address _contractAddress, uint256 _tokenId)
        internal
        view
    {
        IERC721 erc721 = IERC721(_contractAddress);
        address owner = erc721.ownerOf(_tokenId);
        require(owner == msg.sender, "owner must have approved contract");
    }

    /////////////////////////////////////////////////////////////////////////
    // _requireNoCurrentAuction
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Require that there be no current auctions.
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     */
    function _requireNoCurrentAuction(
        address _contractAddress,
        uint256 _tokenId
    ) internal view {
        require(
            !_hasReserveAuction(_contractAddress, _tokenId),
            "cannot have a current reserve auction"
        );
        require(
            !_hasScheduledAuction(_contractAddress, _tokenId),
            "cannot have a current scheduled auction"
        );
    }

    /////////////////////////////////////////////////////////////////////////
    // _hasReserveAuction
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Returns whether ther is a reserve auction for the token.
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     */
    function _hasReserveAuction(address _contractAddress, uint256 _tokenId)
        internal
        view
        returns (bool)
    {
        return
            reserveAuctions[_contractAddress][_tokenId].auctionCreator !=
            address(0);
    }

    /////////////////////////////////////////////////////////////////////////
    // _hasScheduledAuction
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Returns whether there is a scheduled auction for the token.
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     */
    function _hasScheduledAuction(address _contractAddress, uint256 _tokenId)
        internal
        view
        returns (bool)
    {
        return
            scheduledAuctions[_contractAddress][_tokenId].auctionCreator !=
            address(0);
    }

    //////////////////////////////////////////////////////////////////////////
    // _cancelReserveAuction
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Cancel a reserve auction.
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uint256 id of the token.
     */

    function _cancelReserveAuction(address _contractAddress, uint256 _tokenId)
        internal
    {
        reserveAuctions[_contractAddress][_tokenId] = ReserveAuction(
            address(0),
            0,
            0,
            0
        );

        _refundBid(_contractAddress, _tokenId);
    }

    /////////////////////////////////////////////////////////////////////////
    // _refundBid
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Internal function to return an existing bid on a token to the
     *      bidder and reset bid.
     * @param _contractAddress address of ERC721 contract.
     * @param _tokenId uin256 id of the token.
     */
    function _refundBid(address _contractAddress, uint256 _tokenId) internal {
        ActiveBid memory currentBid = currentBids[_contractAddress][_tokenId];
        if (currentBid.bidder == address(0)) {
            return;
        }

        currentBids[_contractAddress][_tokenId] = ActiveBid(address(0), 0, 0);

        // refund the bidder
        Payments.refund(
            currentBid.marketplaceFee,
            currentBid.bidder,
            currentBid.amount
        );
    }
