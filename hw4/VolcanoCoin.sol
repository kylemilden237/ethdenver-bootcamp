// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract VolcanoCoin {

    uint256 totalSupply = 10000;
    address owner;
    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;

    event supplyChange(uint256);
    event transfer(uint256, address);

    struct Payment {
        uint256 amount;
        address receiver;
    }

    constructor() {
        owner = msg.sender;
        balances[owner] = 10000;
    }

    modifier ownerOnly() {
        if(msg.sender == owner) {
            _;
        }
    }

    function increaseTotalSupply() public ownerOnly {
        totalSupply += 1000;
        balances[owner] += 1000;
        emit supplyChange(totalSupply);
    }

    function transferCoins(address receiver, uint256 amount) public {
        assert(amount > 0);
        require(balances[msg.sender] >= amount, "Sender does not have enough balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        payments[msg.sender].push(Payment(amount, receiver));
        emit transfer(amount, receiver);
    }

    function getTotalSupply() public view returns(uint256) {
        return totalSupply;
    }

    function getBalance(address addr) public view returns(uint256) {
        return balances[addr];
    }

    function getPayments(address addr) public view returns(Payment[] memory) {
        return payments[addr];
    }

}
