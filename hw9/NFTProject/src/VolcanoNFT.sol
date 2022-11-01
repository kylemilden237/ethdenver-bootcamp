// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";

contract VolcanoNFT is ERC721 {
    uint256 totalSupply;
    uint256 cost = 0;

    constructor() ERC721("VolcanoCoin", "VC") {}

    function mint() public payable {
        require(msg.value >= cost, "Ether value sent is below the price");
        _mint(msg.sender, _getTokenId());
        totalSupply++;
    }

    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function _getTokenId() internal view returns (uint256) {
        return totalSupply + 1;
    }
}
