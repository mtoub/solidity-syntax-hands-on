// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Concept: inheritance.
//   is         inherit from another contract
//   virtual    this function may be replaced by a child
//   override   this function replaces the parent's
//   super      call the next contract up the inheritance chain
//
// Try: deploy A and B and call foo on each. Deploy Child and call who.
// Deploy WorldGreeter and call greet. Try to deploy GreeterBase.
// Look for: "Child > Base2", and Remix refusing to deploy GreeterBase.

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

contract B is A {
    function foo() public pure override returns (string memory) {
        return "B";
    }
}

// Multiple inheritance: parents are listed from most base to most derived
contract Base1 {
    function who() public pure virtual returns (string memory) {
        return "Base1";
    }
}

contract Base2 {
    function who() public pure virtual returns (string memory) {
        return "Base2";
    }
}

contract Child is Base1, Base2 {
    // Defined in both parents, so the override names both.
    // super refers to the last parent in the list: Base2.
    function who() public pure override(Base1, Base2) returns (string memory) {
        return string.concat("Child > ", super.who());
    }
}

// An interface, an abstract contract and a concrete contract together
interface IGreeter {
    function greet() external view returns (string memory);
}

abstract contract GreeterBase is IGreeter {
    function name() internal view virtual returns (string memory);

    function greet() external view returns (string memory) {
        return string.concat("Hello, ", name());
    }
}

contract WorldGreeter is GreeterBase {
    function name() internal pure override returns (string memory) {
        return "world";
    }
}

// Challenge: swap the parents to "Child is Base2, Base1". What does who return?
