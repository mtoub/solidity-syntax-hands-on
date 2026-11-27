// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";
import "./IVault.sol";

// Concept: fixing the bug by reordering, with no lock at all.
// The pattern is called checks-effects-interactions:
//   checks        validate the request
//   effects       update the contract's own state
//   interactions  only then call other addresses
//
// When the attacker re-enters, the balance on record is already 0, so the
// second withdraw fails its check.
//
// Try: deposit 10 ETH from one account, then attack with Attacker.sol.
// Look for: "balance on record 0" on the re-entrant call.
contract SafeOrderVault is IVault {
    mapping(address => uint256) public balances;

    event Deposited(address indexed account, uint256 amount);
    event Withdrawn(address indexed account, uint256 amount);

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        console.log("Vault.deposit: %s wei from %s", msg.value, msg.sender);
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        console.log("Vault.withdraw: balance on record %s, vault holds %s", amount, address(this).balance);

        // Check
        require(amount > 0, "Nothing to withdraw");

        // Effect: the books are updated before any ETH leaves
        balances[msg.sender] = 0;

        // Interaction
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");

        console.log("Vault.withdraw: done, vault holds %s", address(this).balance);
        emit Withdrawn(msg.sender, amount);
    }

    function totalHeld() external view returns (uint256) {
        return address(this).balance;
    }
}
