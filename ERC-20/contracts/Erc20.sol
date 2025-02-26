// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract MarToken {
    // state variables
    string public name = "MarToken";
    string public symbol = "MAR";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    // mapping for balances and allowances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Custom errors (gas efficient)
    error InsufficientBalance();
    error AllowanceExceeded();
    error InvalidAddress();

    // events 
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // initialize total supply (constructor)
    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // Transfer function
    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (_to == address(0)) revert InvalidAddress();
        if (balanceOf[msg.sender] < _value) revert InsufficientBalance();

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Approve function (grants spending permission)
    function approve(address _spender, uint256 _value) public returns (bool success) {
        if (_spender == address(0)) revert InvalidAddress();
        
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // TransferFrom function (allows spending on behalf of owner)
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (_from == address(0) || _to == address(0)) revert InvalidAddress();
        if (balanceOf[_from] < _value) revert InsufficientBalance();
        if (allowance[_from][msg.sender] < _value) revert AllowanceExceeded();

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }
}