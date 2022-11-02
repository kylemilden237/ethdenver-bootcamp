// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/VolcanoNFT.sol";
import "../src/VolcanoCoin.sol";

contract VolcanoNFTTest is Test {

    VolcanoNFT public vnft;
    VolcanoCoin public vcoin;

    string tokenURI = "https://google.com/";
    string tokenURI1 = "https://google.com/1.json";

    address addr1 = address(1);
    address addr2 = address(2);

    function setUp() public {
        vnft = new VolcanoNFT(tokenURI);
        vcoin = new VolcanoCoin(address(vnft));
        vnft.setVolcanoCoin(address(vcoin));
    }

    function testMintWithoutPayingEther() public {
        vm.prank(addr1);
        vm.expectRevert();
        vnft.mintWithEther();
    }

    function testMintWithEther() public {
        _mintWithEther(addr1);
    }

    function testMintWithoutPayingVolcanoCoin() public {
        assertEq(vcoin.getBalance(vcoin.owner()), 10000);

        vm.prank(addr1);
        vm.expectRevert();
        vnft.mintWithVolcanoCoin();
    }

    function testMintWithVolcanoCoin() public {
        assertEq(vcoin.getBalance(vcoin.owner()), 10000);
        
        vm.prank(vcoin.owner());
        vcoin.transferCoins(addr1, 1000);
        assertEq(vcoin.getBalance(addr1), 1000);
        assertEq(vcoin.getBalance(vcoin.owner()), 9000);

        _mintWithVolcanoCoin(addr1);
        assertEq(vcoin.getBalance(addr1), 0);
        assertEq(vcoin.getBalance(vnft.owner()), 10000);
    }

    function testTransfer() public {
        _mintWithEther(addr1);

        vm.prank(addr1);
        vnft.safeTransferFrom(addr1, addr2, 1);
        assertEq(vnft.ownerOf(1), addr2);
        assertEq(vnft.balanceOf(addr1), 0);
        assertEq(vnft.balanceOf(addr2), 1);
    }

    function testTokenURIWithoutMint() public {
        vm.expectRevert();
        vnft.tokenURI(1);
    }

    function testTokenURI() public {
        _mintWithEther(addr1);
        assertEq(vnft.tokenURI(1), tokenURI1);
    }

    function _mintWithEther(address _addr) private {
        vm.prank(_addr);
        vm.deal(_addr, 1 ether);
        vnft.mintWithEther{value: 0.01 ether}();
        assertEq(vnft.getTotalSupply(), 1);
        assertEq(vnft.ownerOf(1), _addr);
    }

    function _mintWithVolcanoCoin(address _addr) private {
        vm.prank(_addr);
        vnft.mintWithVolcanoCoin();
        assertEq(vnft.getTotalSupply(), 1);
        assertEq(vnft.ownerOf(1), _addr);
    }

}
