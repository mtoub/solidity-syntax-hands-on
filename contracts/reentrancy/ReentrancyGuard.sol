// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: a reentrancy lock built from a modifier and transient storage.
//
// The modifier wraps a function like this:
//   lock taken?   yes: revert.  no: take the lock
//   run the function body
//   release the lock
//
// While the body is running, the lock is taken. Any call that comes back
// into a guarded function during that time finds the lock and is rejected.
//
// Why transient storage: the lock only matters while a transaction is
// running. Transient storage is cheap (about 100 gas per access) and is
// wiped automatically when the transaction ends, so a lock can never stay
// stuck from one transaction to the next.
abstract contract ReentrancyGuard {
    error ReentrantCall();

    // false at the start of every transaction
    bool transient private _locked;

    modifier nonReentrant() {
        if (_locked) {
            console.log("    nonReentrant: lock already taken, rejecting the call");
            revert ReentrantCall();
        }

        _locked = true;
        console.log("    nonReentrant: lock taken");

        _;

        _locked = false;
        console.log("    nonReentrant: lock released");
    }
}
