// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Remix VM understands Hardhat's console library: console.log output is
// printed in the Remix terminal when the function runs.
import "hardhat/console.sol";

// Concept: the two ways to see what a contract is doing.
//   console.log  a development tool, visible only on a local VM
//   event        a permanent log entry stored with the transaction
//
// Try: deploy, click sayHello, then expand the transaction in the terminal.
// Look for: the console.log lines above the transaction, and the "logs"
// field inside it holding the decoded Hello event.
contract HelloLogs {
    event Hello(address indexed from, string message);

    constructor() {
        console.log("HelloLogs deployed by", msg.sender);
    }

    // Sends a transaction: prints to the console and emits an event
    function sayHello(string calldata message) external {
        console.log("sayHello called by", msg.sender);
        console.log("message:", message);
        emit Hello(msg.sender, message);
    }

    // A read-only call: no transaction, no event, but console.log still prints
    function whoAmI() external view returns (address) {
        console.log("whoAmI called by", msg.sender);
        return msg.sender;
    }
}

// Challenge: add a function logNumber(uint256 n) that prints n and n * 2
// with a single console.log call.
