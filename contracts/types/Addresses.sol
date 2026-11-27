// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: the address type. An address identifies either a user account
// (controlled by a key) or a contract (controlled by its code).
//   msg.sender        who called the current function
//   address(this)     the contract's own address
//   someAddr.balance  how much ETH an address holds, in wei
//   someAddr.code     the contract code at an address (empty for a user)
//
// Try: read owner, call balanceOf with another account's address, call
// isContract with a user address and then with this contract's own address.
// Look for: 100 ETH shown as 100000000000000000000 wei; isContract false
// for a user, true for a contract.
contract Addresses {
    address public owner;

    constructor() {
        owner = msg.sender;
        console.log("deployed by ", msg.sender);
        console.log("contract is at", address(this));
    }

    function balanceOf(address account) external view returns (uint256) {
        console.log("balance of %s is %s wei", account, account.balance);
        return account.balance;
    }

    function isContract(address account) external view returns (bool) {
        return account.code.length > 0;
    }

    function whoIsCalling() external view returns (address caller, bool callerIsOwner) {
        return (msg.sender, msg.sender == owner);
    }
}

// Challenge: add a function that returns the balance of whoever calls it.
