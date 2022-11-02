// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVolcanoCoin {

    struct Payment {
      uint256 amount;
      address receiver;
    }

    function increaseTotalSupply() external;

    function transferCoins(address _receiver, uint256 _amount) external;

    function transferCoins(address _sender, address _receiver, uint256 _amount) external;

    function getTotalSupply() external view returns(uint256);

    function getBalance(address _addr) external view returns(uint256);

    function getPayments(address _addr) external view returns(Payment[] memory);

}