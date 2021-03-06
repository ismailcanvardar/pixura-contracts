pragma solidity 0.5.17;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "SuperRareMarketAuctionV2.sol";

contract TestExpensiveWallet is Ownable {
    /**
     * @dev A costly payment method. Should fail on `<address>.transfer`
     */
    function() external payable {
        uint256 a = 0;
        while (a < 1500000) {
            a = a + 1;
        }
        _makePayable(owner()).transfer(msg.value);
    }

    /**
     * @dev Claim the money as the owner.
     * @param _escrowAddress address of the contract escrowing the money to be claimed
     */
    function claimMoney(address _escrowAddress) external onlyOwner {
        SuperRareMarketAuctionV2(_escrowAddress).withdrawPaymentsWithGas(
            _makePayable(address(this))
        );
    }

    /**
     * @dev Place a bid for the owner
     * @param _newBidAmount uint256 value in wei to bid, plus marketplace fee.
     * @param _originContract address of the contract storing the token.
     * @param _tokenId uint256 ID of the token
     * @param _market address of the marketplace to make the bid
     */
    function bid(
        uint256 _newBidAmount,
        address _originContract,
        uint256 _tokenId,
        address _market
    ) public payable {
        SuperRareMarketAuctionV2(_market).bid.value(msg.value)(
            _newBidAmount,
            _originContract,
            _tokenId
        );
    }

    /////////////////////////////////////////////////////////////////////////
    // _makePayable
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Internal function to set a bid.
     * @param _address non-payable address
     * @return payable address
     */
    function _makePayable(address _address)
        internal
        view
        returns (address payable)
    {
        return address(uint160(_address));
    }
}
