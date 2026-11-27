// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: transient storage. A variable marked transient behaves like a
// state variable, with one difference: it is wiped at the end of every
// transaction.
//   storage     kept forever, expensive to write
//   transient   kept until the transaction ends, cheap to write
//
// Within one transaction, a transient value survives across function calls,
// including calls coming back in from other contracts. That makes it a good
// place for a "busy" flag, which is what a reentrancy lock is.
//
// Try: click bump three times, then bumpThreeTimes, then readTransient.
// Deploy Caller with this contract's address and click bumpTwice.
// Look for: the persistent count climbing while the transient count restarts
// at 1 in every new transaction.
contract TransientStorage {
    uint256 public persistentCount;
    uint256 transient private txCount;

    event Bumped(uint256 persistentCount, uint256 transientCount);

    function bump() public {
        persistentCount += 1;
        txCount += 1;
        console.log("bump: persistent %s, transient %s", persistentCount, txCount);
        emit Bumped(persistentCount, txCount);
    }

    // Three bumps in a single transaction: the transient count reaches 3
    function bumpThreeTimes() external {
        bump();
        bump();
        bump();
    }

    // Always 0: each call starts with a clean transient storage
    function readTransient() external view returns (uint256) {
        return txCount;
    }
}

interface IBumpable {
    function bump() external;
}

// Calls bump twice from another contract, in one transaction
contract Caller {
    IBumpable public immutable target;

    constructor(IBumpable target_) {
        target = target_;
    }

    function bumpTwice() external {
        console.log("Caller: first external call");
        target.bump();
        console.log("Caller: second external call, same transaction");
        target.bump();
    }
}

// Challenge: add a function that returns txCount right after calling bump()
// in the same function. Is the result 0 or 1? Why?
