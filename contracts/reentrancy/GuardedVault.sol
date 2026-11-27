// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";
import "./IVault.sol";
import "./ReentrancyGuard.sol";

// Concept: fixing the bug with a lock.
// The body of withdraw is the same as in VulnerableVault, still in the unsafe
// order. The only change is the nonReentrant modifier.
//
// Try: deposit 10 ETH from one account, then attack with Attacker.sol.
// Look for: "lock already taken" in the console, and the vault still holding
// its 10 ETH afterwards.
contract GuardedVault is IVault, ReentrancyGuard {
    mapping(address => uint256) public balances;

    event Deposited(address indexed account, uint256 amount);
    event Withdrawn(address indexed account, uint256 amount);

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        console.log("Vault.deposit: %s wei from %s", msg.value, msg.sender);
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() external nonReentrant {
        uint256 amount = balances[msg.sender];
        console.log("Vault.withdraw: balance on record %s, vault holds %s", amount, address(this).balance);

        require(amount > 0, "Nothing to withdraw");

        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");

        balances[msg.sender] = 0;
        console.log("Vault.withdraw: balance set to 0, vault holds %s", address(this).balance);
        emit Withdrawn(msg.sender, amount);
    }

    function totalHeld() external view returns (uint256) {
        return address(this).balance;
    }
}
