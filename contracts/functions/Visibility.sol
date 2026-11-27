// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Concept: who may call a function.
//   public     anyone, from outside or inside
//   external   from outside only
//   internal   this contract and the contracts that inherit from it
//   private    this contract only
//
// Try: deploy Base and count the buttons. Call callAllFromInside.
// Deploy Derived and call callFromChild.
// Look for: no button for intFn and privFn.
contract Base {
    function pubFn() public pure returns (string memory) {
        return "public";
    }

    function extFn() external pure returns (string memory) {
        return "external";
    }

    function intFn() internal pure returns (string memory) {
        return "internal";
    }

    function privFn() private pure returns (string memory) {
        return "private";
    }

    function callAllFromInside()
        public
        view
        returns (string memory, string memory, string memory, string memory)
    {
        // An external function is reached from inside through this.extFn(),
        // which makes a real call to the contract's own address
        return (pubFn(), this.extFn(), intFn(), privFn());
    }
}

contract Derived is Base {
    function callFromChild() public pure returns (string memory, string memory) {
        // privFn();   // does not compile: private is not visible in children
        return (pubFn(), intFn());
    }
}

// Note: private hides a function or variable from other contracts, not from
// people. Everything stored on a blockchain can be read by anyone.
//
// Challenge: uncomment privFn() in Derived and read the compiler error.
