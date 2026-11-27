// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: arrays.
//   uint256[5]   fixed size, known at compile time, filled with zeros
//   uint256[]    dynamic size, grows with push and shrinks with pop
//
// Try: setFixed(2, 42) then fixedArr(2). setFixed(5, 1). push(10), push(20),
// length, pop, length, getAll.
// Look for: Panic 0x32 (index out of bounds) on setFixed(5, 1).
contract Arrays {
    uint256[5] public fixedArr;
    uint256[] public dynArr;

    event Pushed(uint256 value, uint256 newLength);
    event Popped(uint256 value, uint256 newLength);

    function setFixed(uint256 index, uint256 value) external {
        // An index of 5 or more reverts
        fixedArr[index] = value;
        console.log("setFixed: fixedArr[%s] = %s", index, value);
    }

    function push(uint256 value) external {
        dynArr.push(value);
        console.log("push: added %s, length now %s", value, dynArr.length);
        emit Pushed(value, dynArr.length);
    }

    function pop() external {
        // Reverts on an empty array
        uint256 last = dynArr[dynArr.length - 1];
        dynArr.pop();
        console.log("pop: removed %s, length now %s", last, dynArr.length);
        emit Popped(last, dynArr.length);
    }

    function length() external view returns (uint256) {
        return dynArr.length;
    }

    // The public getter dynArr(i) returns one element. Returning the whole
    // array needs an explicit function.
    function getAll() external view returns (uint256[] memory) {
        return dynArr;
    }
}

// Challenge: add sum() that loops over dynArr and returns the total.
