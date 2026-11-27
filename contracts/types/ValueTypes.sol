// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: value types. Each variable holds its own copy of the data.
//   bool      true or false
//   uint256   unsigned integer, 0 to 2^256 - 1 ("uint" is the same type)
//   int256    signed integer
//   uint8     small unsigned integer, 0 to 255
//   address   a 20-byte account identifier
//   enum      a named list of choices, stored as a small number
//
// Try: deploy and click every blue button. Then call setColor with 2.
// Look for: the sizes of the limits, and the enum shown as a number.
contract ValueTypes {
    enum Color { Red, Green, Blue }

    bool public flag = true;
    uint256 public maxUint256 = type(uint256).max;
    int256 public minInt256 = type(int256).min;
    uint8 public small = 255;
    address public deployer;
    Color public color; // default value: the first member, Red (0)

    // constant: fixed at compile time, takes no storage
    uint256 public constant ONE_ETHER_IN_WEI = 1 ether;

    event ColorChanged(Color from, Color to);

    constructor() {
        deployer = msg.sender;
    }

    function limits() public pure returns (uint8 maxU8, int8 minI8, int8 maxI8) {
        return (type(uint8).max, type(int8).min, type(int8).max);
    }

    // Enums are passed as numbers: 0 = Red, 1 = Green, 2 = Blue.
    // A number outside the list makes the call revert.
    function setColor(Color newColor) external {
        console.log("setColor: from %s to %s", uint256(color), uint256(newColor));
        emit ColorChanged(color, newColor);
        color = newColor;
    }

    function toggle() external {
        flag = !flag;
        console.log("toggle: flag is now", flag);
    }
}

// Challenge: add an int256 state variable and a function that subtracts from
// it, then make it go below zero. Compare with what uint8 does in Overflow.sol.
