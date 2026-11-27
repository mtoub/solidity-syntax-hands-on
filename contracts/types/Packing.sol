// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Concept: storage is organised in 32-byte slots, and writing a new slot is
// the most expensive thing a contract does. Small types declared next to each
// other share a slot.
//
// Try: deploy both contracts, call store with 1, 2, 3 on each, once.
// Look for: the "execution cost" of the two transactions in the terminal.
// Packed is about 43,500 gas cheaper.
//
// There is no console.log here on purpose: logging costs gas on the VM and
// would blur the comparison.

// Three values in three storage slots
contract Unpacked {
    uint256 public a;
    uint256 public b;
    uint256 public c;

    function store(uint256 x, uint256 y, uint256 z) external {
        a = x;
        b = y;
        c = z;
    }
}

// Three values in one slot: 3 x 8 bytes = 24 bytes, which fits in 32
contract Packed {
    uint64 public a;
    uint64 public b;
    uint64 public c;

    function store(uint64 x, uint64 y, uint64 z) external {
        a = x;
        b = y;
        c = z;
    }
}

// Challenge: write a contract with the fields uint64, uint256, uint64 in that
// order. How many slots does it use? Reorder the fields to use fewer.
