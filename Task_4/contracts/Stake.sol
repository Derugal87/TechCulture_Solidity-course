// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./MyToken.sol";

contract Stake is MyToken 
{

	MyToken token;

	struct staker_info
	{ 
        	uint deposit; 
        	uint timeStamp; 
    	}

	mapping(address => bool) public staker_status;
	mapping(address => staker_info) public staker_data;

	constructor(address _address)
	{
		require(_address != address(0), "it can't be zero address");
		token = MyToken(_address);
	}

	function calculateProfit(uint _deposit) public pure returns (uint)
	{
        	return uint(_deposit * 5 / 100);
    	}

	function depositStake(uint _deposit) public payable 
	{
		require(staker_status[msg.sender] == false, "staking is already in the process");
        	require(_deposit > 0, "Stake must be greater than 0");
        	require(token.balanceOf(msg.sender) >= _deposit, "Insufficient funds to deposit stake");
		token.transferFrom(msg.sender, address(this), _deposit);
		staker_data[msg.sender] = staker_info({ deposit: _deposit, timeStamp: block.timestamp + 60 });
		staker_status[msg.sender] = true;
    	}

	function withdrawStake(uint _deposit) public payable 
	{
		require(staker_status[msg.sender] == true, "staking isn't in the process");
		require(staker_data[msg.sender].timeStamp < block.timestamp, "HODL period is still goin on");
        	require(_deposit > 0, "Stake must be greater than 0");
        	require(staker_data[msg.sender].deposit >= _deposit, "Insufficient funds to withdraw stake");
		token.transfer(msg.sender, _deposit + calculateProfit(_deposit));
		staker_data[msg.sender] = staker_info({ deposit: 0, timeStamp: 0 });
		staker_status[msg.sender] = false;
   	}
}
