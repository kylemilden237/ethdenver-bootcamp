// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/VolcanoCoin.sol";

contract VolcanoCoinTest is Test {
    VolcanoCoin public volcanoCoin;

    function setUp() public {
        volcanoCoin = new VolcanoCoin();
    }

    function testInitialSupply() public {
        assertEq(volcanoCoin.getTotalSupply(), 10000);
    }

    function testIncreaseTotalSupplyOwner() public {
        volcanoCoin.increaseTotalSupply();
        assertEq(volcanoCoin.getTotalSupply(), 11000);
        volcanoCoin.increaseTotalSupply();
        assertEq(volcanoCoin.getTotalSupply(), 12000);
    }

    function testIncreaseTotalSupplyNonOwner() public {
        vm.expectRevert();
        vm.prank(address(0));
        volcanoCoin.increaseTotalSupply();
    }
}
