// SPDX-License-Identifier: UNLICENSED

import "openzeppelin-contracts/access/Ownable.sol";

pragma solidity ^0.8.0;

contract VolcanoCoin is Ownable {

    uint256 totalSupply = 10000;
    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;

    event supplyChange(uint256);
    event transfer(uint256, address);

    struct Payment {
        uint256 amount;
        address receiver;
    }

    constructor() {
        balances[owner()] = 10000;
    }

    function increaseTotalSupply() external onlyOwner {
        totalSupply += 1000;
        balances[owner()] += 1000;
        emit supplyChange(totalSupply);
    }

    function transferCoins(address receiver, uint256 amount) external {
        assert(amount > 0);
        require(balances[msg.sender] >= amount, "Sender does not have enough balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        recordPayment(msg.sender, receiver, amount);
        emit transfer(amount, receiver);
    }

    function getTotalSupply() external view returns(uint256) {
        return totalSupply;
    }

    function getBalance(address addr) external view returns(uint256) {
        return balances[addr];
    }

    function getPayments(address addr) external view returns(Payment[] memory) {
        return payments[addr];
    }

    function recordPayment(address sender, address receiver, uint256 amount) private {
        payments[sender].push(Payment(amount, receiver));
    }

}
