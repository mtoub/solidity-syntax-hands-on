// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: a mapping is a key-value store with direct access.
//   every possible key already exists, with the default value (0, false, ...)
//   a mapping has no length and cannot be looped over
//
// Try: read balances with any address. From one account call update(500),
// from another update(250). Then accountCount and total.
// Look for: 0 for an address that was never written; total 750.
contract Mappings {
    // Balance of each user
    mapping(address => uint256) public balances;

    // A mapping cannot be iterated: keep the keys in an array when needed
    address[] private accounts;
    mapping(address => bool) private known;

    event BalanceUpdated(address indexed account, uint256 oldAmount, uint256 newAmount);

    function update(uint256 amount) public {
        uint256 old = balances[msg.sender];
        balances[msg.sender] = amount;

        if (!known[msg.sender]) {
            known[msg.sender] = true;
            accounts.push(msg.sender);
            console.log("update: first time we see", msg.sender);
        }

        console.log("update: balance %s -> %s", old, amount);
        emit BalanceUpdated(msg.sender, old, amount);
    }

    function accountCount() external view returns (uint256) {
        return accounts.length;
    }

    function total() external view returns (uint256 sum) {
        for (uint256 i = 0; i < accounts.length; i++) {
            sum += balances[accounts[i]];
        }
    }
}

// Challenge: add a nested mapping
//   mapping(address => mapping(address => uint256)) public allowance;
// and a function approve(address spender, uint256 amount) that fills it.
