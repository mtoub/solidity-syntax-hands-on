// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: function syntax and return values.
//   function name(inputs) visibility mutability returns (outputs) { ... }
//   a function can return several values at once
//   return values can be named, then assigned like local variables
//
// Try: getMath, minMax(7, 3), useTuple.
// Look for: Remix showing the names min and max next to the results.
contract Returns {
    // Several return values
    function getMath() public pure returns (uint256, uint256) {
        return (10, 20);
    }

    // Named return values: no return statement needed
    function minMax(uint256 x, uint256 y) public pure returns (uint256 min, uint256 max) {
        if (x < y) {
            min = x;
            max = y;
        } else {
            min = y;
            max = x;
        }
    }

    // Destructuring: unpack the values, skipping the ones not needed
    function useTuple() public pure returns (uint256 sum) {
        (uint256 a, uint256 b) = getMath();
        (, uint256 onlyB) = getMath();
        console.log("useTuple: a %s, b %s, onlyB %s", a, b, onlyB);
        sum = a + b + onlyB;
    }
}

// Challenge: write divide(uint256 a, uint256 b) returning both the quotient
// and the remainder.
