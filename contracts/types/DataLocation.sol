// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: where data lives. Arrays, strings and structs need a location.
//   storage    the contract's permanent state; a storage variable is a reference
//   memory     a temporary copy that disappears when the call ends
//   calldata   the read-only input of an external call, never copied
// (transient, the fourth location, has its own file: TransientStorage.sol)
//
// Try: read stored. Call updateViaMemory(999) and read stored again.
// Call updateViaStorage(250) and read stored again.
// Look for: stored unchanged after the memory version, changed after the
// storage version.
contract DataLocation {
    struct Payment {
        uint256 amount;
        string currency;
    }

    Payment public stored = Payment(100, "EUR");

    event AmountChanged(uint256 oldAmount, uint256 newAmount);

    // storage: p points at the state variable, so the change persists
    function updateViaStorage(uint256 newAmount) external {
        Payment storage p = stored;
        uint256 old = p.amount;
        p.amount = newAmount;
        console.log("storage: copy says %s, state says %s", p.amount, stored.amount);
        emit AmountChanged(old, newAmount);
    }

    // memory: p is a copy, the state variable is untouched
    function updateViaMemory(uint256 newAmount)
        external
        view
        returns (uint256 copyAmount, uint256 stateAmount)
    {
        Payment memory p = stored;
        p.amount = newAmount;
        console.log("memory:  copy says %s, state says %s", p.amount, stored.amount);
        return (p.amount, stored.amount);
    }

    // calldata: read-only input, no copy made
    function sumCalldata(uint256[] calldata values) external pure returns (uint256 total) {
        // values[0] = 1;   // does not compile: calldata is read-only
        for (uint256 i = 0; i < values.length; i++) {
            total += values[i];
        }
    }

    // memory parameter: the input is copied and can be modified
    function doubleFirst(uint256[] memory values) public pure returns (uint256[] memory) {
        values[0] *= 2;
        return values;
    }
}

// Challenge: uncomment the line in sumCalldata and read the compiler error.
