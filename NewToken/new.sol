// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Token {
    uint public _totalSupply = 1000000e18;
    address public owner;

    mapping(address => uint) public _balanceOf;
    mapping(address => mapping(address => uint)) public _allowance;
    mapping(address => bool) public _blacklist;

    string public name = "NewToken";
    string public symbol = "NT";
    uint8 public decimal = 18;

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approve(address indexed owner, address indexed spender, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    function blacklisted(address _address) external OnlyOwner {
        require(!_blacklist[_address], "blacklisted");
        _blacklist[_address] = true;
    }

    function totalSupply() external view returns(uint) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns(uint) {
        return _balanceOf[account];
    }

    function transfer(address recipient, uint amount) external returns(bool) {
        require(!_blacklist[recipient], "already blacklisted");
        _balanceOf[msg.sender] -= amount;
        _balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address _owner, address spender) external view returns(uint) {
        return _allowance[_owner][spender];
    }

    function mint(address _account, uint amount) external OnlyOwner { 
        _balanceOf[_account] += amount;
        _totalSupply += amount;
    }    
    
    function approve(address spender, uint amount) external returns(bool) {
        _allowance[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) external returns(bool) {
        _allowance[sender][recipient] -= amount;
        _balanceOf[sender] -= amount;
        _balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
