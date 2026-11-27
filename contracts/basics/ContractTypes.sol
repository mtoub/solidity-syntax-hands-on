// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: the four kinds of contract-level declarations.
//   interface          function signatures only, nothing implemented
//   library            reusable code without state
//   abstract contract  partly implemented, cannot be deployed
//   contract           complete and deployable
//
// Try: deploy FeeCalculator with 25 (0.25%), call quote with 1000000.
// Then select FeeBase in the contract list and try to deploy it.
// Look for: fee 2500 and net 997500; Remix refuses to deploy FeeBase.

// Interface: what a fee quoter must offer. All functions are external.
interface IFeeQuote {
    function quote(uint256 amount) external view returns (uint256 fee, uint256 net);
}

// Library: reusable maths. bps = basis points, 1 bps = 0.01%
library FeeMath {
    uint256 internal constant BPS_DENOMINATOR = 10_000;

    function applyBps(uint256 amount, uint256 bps) internal pure returns (uint256) {
        return (amount * bps) / BPS_DENOMINATOR;
    }
}

// Abstract contract: implements quote, leaves feeBps to its children
abstract contract FeeBase is IFeeQuote {
    // Lets us write amount.applyBps(...) on any uint256
    using FeeMath for uint256;

    // No body: a child contract must provide it
    function feeBps() public view virtual returns (uint256);

    function quote(uint256 amount) external view returns (uint256 fee, uint256 net) {
        fee = amount.applyBps(feeBps());
        net = amount - fee;
        console.log("quote: amount %s, fee %s, net %s", amount, fee, net);
    }
}

// Contract: fills in the missing piece, so it can be deployed
contract FeeCalculator is FeeBase {
    // immutable: set once in the constructor, then read-only
    uint256 private immutable bps;

    constructor(uint256 bps_) {
        bps = bps_;
        console.log("FeeCalculator deployed with bps:", bps_);
    }

    function feeBps() public view override returns (uint256) {
        return bps;
    }
}

// Challenge: add a second contract FlatFeeCalculator is IFeeQuote that
// charges a fixed fee, whatever the amount.
