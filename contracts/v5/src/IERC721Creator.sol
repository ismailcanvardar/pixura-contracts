pragma solidity 0.5.17;

/**
 * @title IERC721 Non-Fungible Token Creator basic interface
 */
contract IERC721Creator {
    /**
     * @dev Gets the creator of the token
     * @param _tokenId uint256 ID of the token
     * @return address of the creator
     */
    function tokenCreator(uint256 _tokenId) external view returns (address);
}
