// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: the anatomy of a contract.
//   pragma           which compiler versions may build this file
//   state variable   lives permanently in the contract's storage
//   constructor      runs once, at deployment
//   function         code anyone can call
//
// Try: deploy with an initial value of 5, read count, click increment,
// read count again. Deploy a second instance with 100.
// Look for: each instance keeps its own count; increment is a transaction
// with a gas cost, reading count is free.
contract Counter {
    // State variable. "public" generates a getter function named count()
    uint256 public count;

    event Incremented(address indexed by, uint256 newCount);

    // Constructor: runs only once, when the contract is deployed
    constructor(uint256 initial) {
        count = initial;
        console.log("Counter deployed, initial count:", initial);
    }

    // Function that changes state: needs a transaction
    function increment() public {
        console.log("increment: count before", count);
        count += 1;
        console.log("increment: count after ", count);
        emit Incremented(msg.sender, count);
    }
}

// Challenge: add a decrement() function that emits a Decremented event.
// What happens when count is 0? See Overflow.sol for the explanation.
