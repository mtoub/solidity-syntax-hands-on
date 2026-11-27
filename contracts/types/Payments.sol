// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: receiving and sending ETH.
//   payable function   may receive ETH with the call (msg.value)
//   receive()          runs when ETH arrives with no function named
//   address payable    an address the contract is allowed to pay
//   to.call{value: x}  the recommended way to send ETH
//   to.transfer(x)     the older way: forwards very little gas
//
// Try: set VALUE to 2 Ether and click deposit. Pay 1 ETH to another account
// with payWithCall. Switch account and try to pay again.
// Look for: the contract balance going 0, 2, 1 ETH; "Not owner" on the last call.
contract Payments {
    address public owner;

    event Deposited(address indexed from, uint256 amount);
    event Paid(address indexed to, uint256 amount, string method);

    constructor() {
        owner = msg.sender;
    }

    // Lets the contract receive plain ETH transfers
    receive() external payable {
        console.log("receive: got %s wei from %s", msg.value, msg.sender);
        emit Deposited(msg.sender, msg.value);
    }

    function deposit() external payable {
        console.log("deposit: got %s wei, balance now %s", msg.value, address(this).balance);
        emit Deposited(msg.sender, msg.value);
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Recommended: forwards the remaining gas and returns a success flag
    // that must be checked
    function payWithCall(address payable to, uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        (bool ok, ) = to.call{value: amount}("");
        require(ok, "Payment failed");
        console.log("payWithCall: sent %s wei, balance now %s", amount, address(this).balance);
        emit Paid(to, amount, "call");
    }

    // Older style: forwards only 2,300 gas and reverts on failure.
    // Recent compilers flag it as deprecated; the warning is expected here.
    function payWithTransfer(address payable to, uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        to.transfer(amount);
        console.log("payWithTransfer: sent %s wei, balance now %s", amount, address(this).balance);
        emit Paid(to, amount, "transfer");
    }
}

// Challenge: add withdrawAll() that sends the whole balance to the owner.
