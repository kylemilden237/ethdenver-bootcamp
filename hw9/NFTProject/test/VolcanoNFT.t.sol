// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/VolcanoNFT.sol";

contract VolcanoNFTTest is Test {
    VolcanoNFT public volcanoNft;

    function setUp() public {
        volcanoNft = new VolcanoNFT();
    }

    function testMint() public {
        vm.prank(address(1));
        volcanoNft.mint();
        assertEq(volcanoNft.getTotalSupply(), 1);
        assertEq(volcanoNft.ownerOf(1), address(1));
    }

    function testTransfer() public {
        vm.prank(address(1));
        volcanoNft.mint();
        assertEq(volcanoNft.getTotalSupply(), 1);
        assertEq(volcanoNft.ownerOf(1), address(1));

        vm.prank(address(1));
        volcanoNft.safeTransferFrom(address(1), address(2), 1);
        assertEq(volcanoNft.ownerOf(1), address(2));
        assertEq(volcanoNft.balanceOf(address(1)), 0);
        assertEq(volcanoNft.balanceOf(address(2)), 1);
    }
}
