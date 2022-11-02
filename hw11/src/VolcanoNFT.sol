// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/access/Ownable.sol";
import "./IVolcanoCoin.sol";

contract VolcanoNFT is ERC721, Ownable {

    uint256 totalSupply;
    uint256 cost = 0.01 ether;
    uint256 volcanoCoinCost = 1000;
    string baseURI;
    IVolcanoCoin vcoin;

    constructor(string memory _baseURI) ERC721("VolcanoNFT", "VOLC") {
        baseURI = _baseURI;
    }

    function mintWithEther() external payable {
        require(msg.value >= cost, "Ether value sent is below the price");
        _mint(msg.sender, _getTokenId());
        totalSupply++;
    }

    function mintWithVolcanoCoin() external {
        require(vcoin.getBalance(msg.sender) >= volcanoCoinCost, "Sender does not have enough VolcanoCoin balance");
        vcoin.transferCoins(msg.sender, owner(), volcanoCoinCost);
        _mint(msg.sender, _getTokenId());
        totalSupply++;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "Token does not exist.");
        return string(abi.encodePacked(baseURI, Strings.toString(_tokenId), '.json'));   
    }

    function getTotalSupply() external view returns (uint256) {
        return totalSupply;
    }

    function setVolcanoCoin(address _addr) external onlyOwner {
        vcoin = IVolcanoCoin(_addr);
    }

    function _getTokenId() internal view returns (uint256) {
        return totalSupply + 1;
    }

}
