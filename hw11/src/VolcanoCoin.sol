// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/access/Ownable.sol";
import "./IVolcanoCoin.sol";

contract VolcanoCoin is IVolcanoCoin, Ownable {

    uint256 totalSupply = 10000;
    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;
    address nftContract;

    event supplyChange(uint256);
    event transfer(uint256, address);

    modifier onlyNftContract() {
      if (msg.sender == nftContract) {
        _;
      }
    }

    constructor(address _nftContract) {
        balances[owner()] = 10000;
        nftContract = _nftContract;
    }

    function increaseTotalSupply() external onlyOwner {
        totalSupply += 1000;
        balances[owner()] += 1000;
        emit supplyChange(totalSupply);
    }

    function transferCoins(address _receiver, uint256 _amount) external {
        assert(_amount > 0);
        require(balances[msg.sender] >= _amount, "Sender does not have enough balance.");
        balances[msg.sender] -= _amount;
        balances[_receiver] += _amount;
        _recordPayment(msg.sender, _receiver, _amount);
        emit transfer(_amount, _receiver);
    }

    function transferCoins(address _sender, address _receiver, uint256 _amount) external onlyNftContract {
        assert(_amount > 0);
        require(balances[_sender] >= _amount, "Sender does not have enough balance.");
        balances[_sender] -= _amount;
        balances[_receiver] += _amount;
        _recordPayment(_sender, _receiver, _amount);
        emit transfer(_amount, _receiver);
    }

    function getTotalSupply() external view returns(uint256) {
        return totalSupply;
    }

    function getBalance(address _addr) external view returns(uint256) {
        return balances[_addr];
    }

    function getPayments(address _addr) external view returns(Payment[] memory) {
        return payments[_addr];
    }

    function _recordPayment(address _sender, address _receiver, uint256 _amount) private {
        payments[_sender].push(Payment(_amount, _receiver));
    }

}