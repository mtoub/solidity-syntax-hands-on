// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: error handling. An error cancels the whole transaction: every
// state change made so far is undone. This is called a revert.
//   require(condition, "text")   check with a text message
//   revert("text")               fail on purpose
//   error Name(args)             custom error: cheaper, carries data
//
// Try: testRequire with 5, 50 and 500. testCustom(5). testRequireCustom(5).
// incrementThenFail, then read counter.
// Look for: the decoded InvalidAmount error, and counter still at 0.
contract Errors {
    error InvalidAmount(uint256 sent, uint256 min);

    uint256 public counter;

    // Classic approach: text messages
    function testRequire(uint256 x) public pure {
        require(x > 10, "Value too small");
        if (x > 100) {
            revert("Too large");
        }
    }

    // Custom error: a short identifier plus its arguments, no text stored
    function testCustom(uint256 x) public pure {
        if (x < 10) {
            revert InvalidAmount(x, 10);
        }
    }

    // require also accepts a custom error
    function testRequireCustom(uint256 x) public pure {
        require(x >= 10, InvalidAmount(x, 10));
    }

    // Atomicity: the revert undoes the increment
    function incrementThenFail() external {
        counter += 1;
        console.log("incrementThenFail: counter is %s for now", counter);
        revert("All changes undone");
    }

    // The same increment without the failure, for comparison
    function incrementThenSucceed() external {
        counter += 1;
        console.log("incrementThenSucceed: counter is", counter);
    }
}

// Challenge: add a custom error TooLarge(uint256 sent, uint256 max) and use
// it in testRequire instead of the text message.
