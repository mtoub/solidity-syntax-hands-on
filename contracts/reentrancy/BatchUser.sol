// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";
import "./IVault.sol";

// Concept: an honest user that calls the vault twice in one transaction.
// The second withdraw starts after the first one has finished, so this is
// not reentrancy, and a correct lock must let it through.
//
// Try: deploy with the GuardedVault address, set VALUE to 2 Ether and click
// depositAndWithdrawTwice. Then remove the line "_locked = false;" from
// ReentrancyGuard.sol, redeploy both contracts and try again.
// Look for: success with the full guard, ReentrantCall once the release
// line is gone.
contract BatchUser {
    IVault public immutable vault;

    constructor(IVault vault_) {
        vault = vault_;
    }

    function depositAndWithdrawTwice() external payable {
        require(msg.value == 2 ether, "Send exactly 2 ether");

        console.log("BatchUser: first deposit and withdraw");
        vault.deposit{value: 1 ether}();
        vault.withdraw();

        console.log("BatchUser: second deposit and withdraw");
        vault.deposit{value: 1 ether}();
        vault.withdraw();

        // Give the ETH back to the caller
        (bool ok, ) = msg.sender.call{value: address(this).balance}("");
        require(ok, "Refund failed");
        console.log("BatchUser: finished, ETH returned to the caller");
    }

    // Accepts the ETH coming back from the vault, and does nothing else
    receive() external payable {}
}
