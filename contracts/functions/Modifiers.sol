// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: a modifier wraps a function with reusable code.
// The placeholder _; marks where the body of the wrapped function runs.
// Code before _; runs first, code after _; runs last.
//
// Try: call setValue(42) as the deployer, then from another account.
// Call setValueLogged(7) and read the console lines in order.
// Look for: "Not owner" from the second account, and the order
// "before the body", "inside the body", "after the body".
contract Modifiers {
    address public owner;
    uint256 public value;

    event ValueChanged(address indexed by, uint256 newValue);
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
    }

    // A check that runs before the function body
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // A modifier can take arguments
    modifier atMost(uint256 x, uint256 max) {
        require(x <= max, "Value too large");
        _;
    }

    // Code on both sides of the body
    modifier logged() {
        console.log("logged: before the body, value is", value);
        _;
        console.log("logged: after the body, value is ", value);
    }

    function setValue(uint256 newValue) external onlyOwner {
        value = newValue;
        emit ValueChanged(msg.sender, newValue);
    }

    // Several modifiers run from left to right
    function setValueLogged(uint256 newValue) external onlyOwner atMost(newValue, 100) logged {
        console.log("setValueLogged: inside the body");
        value = newValue;
        emit ValueChanged(msg.sender, newValue);
    }

    function changeOwner(address newOwner) external onlyOwner {
        emit OwnerChanged(owner, newOwner);
        owner = newOwner;
    }
}

// Challenge: write a modifier notZero(uint256 x) and apply it to setValue.
