// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: arithmetic is checked. Going past the limits of a type makes the
// transaction revert, unless the code opts out with an unchecked block.
//
// Try: click addOneChecked (confirm sending when Remix warns), read small,
// then click addOneUnchecked and read small again.
// Look for: a Panic error with code 0x11 on the checked call, and small
// wrapping around to 0 on the unchecked one.
contract Overflow {
    uint8 public small = 255; // already at the maximum for uint8

    event Wrapped(uint8 from, uint8 to);

    // Checked arithmetic, the default: 255 + 1 reverts
    function addOneChecked() public {
        console.log("addOneChecked: small before", small);
        small += 1;
        // Never reached while small is 255
        console.log("addOneChecked: small after ", small);
    }

    // Unchecked block: 255 + 1 silently wraps around to 0
    function addOneUnchecked() public {
        uint8 before = small;
        unchecked {
            small += 1;
        }
        console.log("addOneUnchecked: %s became %s", before, small);
        emit Wrapped(before, small);
    }

    function reset() external {
        small = 255;
    }
}

// Challenge: add subOneChecked() and call it when small is 0.
// Which Panic code do you get?
