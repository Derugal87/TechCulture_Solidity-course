// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract MyToken {
    uint public _totalSupply = 1000000e18;
    address public owner;

    mapping(address => uint) public _balanceOf;
    mapping(address => mapping(address => uint)) public _allowance;
    mapping(address => bool) private _blacklist;

    string public _name = "NewToken";
    string public _symbol = "NT";
    uint8 public _decimals = 18;

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approve(address indexed owner, address indexed spender, uint amount);


    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        mint();
    }

    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function to_blacklist(address _address) public onlyOwner {
        require(!_blacklist[_address], "this address is now blacklisted");
        _blacklist[_address] = true;
    }

    function totalSupply() public view returns(uint) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns(uint) {
        return _balanceOf[account];
    }

    function transfer(address recipient, uint amount) public returns(bool) {
        require(!_blacklist[msg.sender], "already blacklisted");
        require(_balanceOf[msg.sender] >= amount, "unsufficient balance");
        _balanceOf[msg.sender] -= amount;
        _balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) public returns(bool) {
        require(!_blacklist[msg.sender], "already blacklisted");
        require(_balanceOf[sender] >= amount, "unsufficient balance");
        _allowance[sender][recipient] -= amount;
        _balanceOf[sender] -= amount;
        _balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function allowance(address _owner, address spender) public view returns(uint) {
        return _allowance[_owner][spender];
    }

    function mint() public {
        require(!_blacklist[msg.sender], "already blacklisted");
        _balanceOf[msg.sender] = 500e18;
    }  
    
    function approve(address spender, uint amount) public returns(bool) {
        _allowance[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }

    
}
