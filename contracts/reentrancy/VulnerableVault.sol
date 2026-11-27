// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";
import "./IVault.sol";

// Concept: a reentrancy bug.
// withdraw sends the ETH first and updates the balance afterwards. Sending
// ETH to a contract runs that contract's code, and that code can call
// withdraw again before the balance has been set to zero.
//
// Try: deposit 10 ETH from one account, then attack with Attacker.sol.
// Look for: the same "balance on record" printed again and again while the
// vault's holdings shrink.
contract VulnerableVault is IVault {
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

        // Interaction: hands control to the caller...
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");

        // Effect: ...and only now updates the books. Too late.
        balances[msg.sender] = 0;
        console.log("Vault.withdraw: balance set to 0, vault holds %s", address(this).balance);
        emit Withdrawn(msg.sender, amount);
    }

    function totalHeld() external view returns (uint256) {
        return address(this).balance;
    }
}
