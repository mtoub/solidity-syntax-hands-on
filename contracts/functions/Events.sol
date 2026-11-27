// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: events are how a contract tells the outside world what happened.
//   declared with event, fired with emit
//   stored in the transaction's logs, much cheaper than storage
//   indexed fields can be searched by applications
//   a contract cannot read events back, only off-chain programs can
//
// Try: set VALUE to 1 Ether and call sendFunds with another account's
// address. Expand the transaction and open "logs". Then call emitThenFail.
// Look for: the decoded Transfer event; no event at all after emitThenFail.
contract Events {
    // Up to three fields can be indexed
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Note(string text);

    function sendFunds(address payable to) public payable {
        (bool ok, ) = to.call{value: msg.value}("");
        require(ok, "Transfer failed");
        console.log("sendFunds: %s wei from %s to %s", msg.value, msg.sender, to);
        emit Transfer(msg.sender, to, msg.value);
    }

    function leaveNote(string calldata text) external {
        emit Note(text);
    }

    // The event is emitted, then the transaction reverts: the revert undoes
    // everything, the event included
    function emitThenFail() external {
        console.log("emitThenFail: emitting Note, then reverting");
        emit Note("you will never see this");
        revert("Reverted after the emit");
    }
}

// Challenge: add a counter of notes and include its value in the Note event.
