// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./VolcanoCoin.sol";

contract VolcanoNFT is ERC721A, Ownable {

    uint8 constant mintAmount = 1;
    uint256 cost = 0.01 ether;
    uint256 volcanoCoinCost = 1000;
    string baseURI;
    VolcanoCoin vcoin;

    constructor() ERC721A("VolcanoNFT", "VOLC") {}

    function mint() external payable {
        require(msg.value >= cost, "Ether value sent is below the price");
        _mint(msg.sender, mintAmount);
    }

    function mintWithVolcanoCoin() external {
        require(vcoin.allowance(msg.sender, address(this)) >= volcanoCoinCost, "Sender has not given contract enough allowance");
        require(vcoin.balanceOf(msg.sender) >= volcanoCoinCost, "Sender does not have enough VolcanoCoin balance");
        vcoin.transferFrom(msg.sender, owner(), volcanoCoinCost);
        _mint(msg.sender, mintAmount);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "Token does not exist.");
        return string(abi.encodePacked(baseURI, Strings.toString(_tokenId), ''));   
    }

    function setVolcanoCoin(address _vcoinAddr) external onlyOwner {
        vcoin = VolcanoCoin(_vcoinAddr);
    }

    function setBaseURI(string calldata _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }

}
