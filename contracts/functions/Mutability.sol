// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: what a function may do with the contract's state.
//   view       reads state, never writes it
//   pure       neither reads nor writes state
//   payable    may receive ETH
//   (nothing)  reads and writes state, refuses ETH
//
// Try: twice(21), add(5), readTotal. Set VALUE to 1 Wei and click pay.
// Set VALUE to 1 Wei again and click add(1).
// Look for: the button colours, and the revert when ETH is sent to add.
contract Mutability {
    uint256 public total;

    event TotalChanged(uint256 oldTotal, uint256 newTotal);

    // view: reads state
    function readTotal() public view returns (uint256) {
        return total;
    }

    // pure: works only with its inputs
    function twice(uint256 x) public pure returns (uint256) {
        return x * 2;
    }

    // default: reads and writes state
    function add(uint256 x) public {
        console.log("add: total %s + %s", total, x);
        emit TotalChanged(total, total + x);
        total += x;
    }

    // payable: accepts ETH with the call
    function pay() public payable {
        console.log("pay: received %s wei", msg.value);
        emit TotalChanged(total, total + msg.value);
        total += msg.value;
    }
}

// Challenge: change readTotal from view to pure and read the compiler error.
