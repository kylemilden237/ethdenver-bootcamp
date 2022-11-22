// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VolcanoCoin is IERC20, Ownable {

    struct Payment {
      uint256 amount;
      address receiver;
    }

    uint256 private constant MAX_UINT256 = 2**256 - 1;

    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;
    mapping(address => mapping(address => uint256)) allowed;

    string public name;
    uint8 public decimals;
    string public symbol;
    uint256 public totalSupply;

    event supplyChange(uint256);

    constructor(uint256 _initialAmount, string memory _tokenName, uint8 _decimalUnits, string memory _tokenSymbol) {
        balances[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
        name = _tokenName;
        decimals = _decimalUnits;
        symbol = _tokenSymbol;
    }

    function transfer(address _to, uint256 _value) public override returns (bool success) {
        require(balances[msg.sender] >= _value);

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        _recordPayment(msg.sender, _to, _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        uint256 allowance_ = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance_ >= _value);

        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance_ < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }

        _recordPayment(_from, _to, _value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function increaseTotalSupply() external onlyOwner returns (bool success) {
        totalSupply += 1000;
        balances[msg.sender] += 1000;
        
        emit supplyChange(totalSupply);
        return true;
    }

    function balanceOf(address _owner) public view override returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public override returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function getPayments(address _owner) external view returns(Payment[] memory) {
        return payments[_owner];
    }

    function _recordPayment(address _sender, address _receiver, uint256 _amount) private {
        payments[_sender].push(Payment(_amount, _receiver));
    }

}