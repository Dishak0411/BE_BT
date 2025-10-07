// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Bank {
    mapping(address => uint) public balances;

    // Deposit function
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    // Withdraw function
    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Show balance
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}
