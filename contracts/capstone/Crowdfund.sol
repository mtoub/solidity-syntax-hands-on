// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";
import "../reentrancy/ReentrancyGuard.sol";

// Capstone: a crowdfunding campaign.
//
// A campaign collects ETH until a deadline. If the goal is reached, the
// owner takes the funds. If not, every backer can take their money back.
//
// The declarations are done. The function bodies marked TODO are yours to
// write. The file compiles as it is, so you can deploy and test after each
// function. docs/capstone.md describes the expected behaviour, and a full
// version is in contracts/solutions/CrowdfundSolution.sol.
contract Crowdfund is ReentrancyGuard {
    enum State { Open, Successful, Failed }

    struct Backer {
        uint256 amount;
        uint64 lastContributionAt;
    }

    address public immutable owner;
    uint256 public immutable goal;
    uint64 public immutable deadline;

    State public state;
    uint256 public raised;
    mapping(address => Backer) public backers;

    event Contributed(address indexed backer, uint256 amount, uint256 raised);
    event Finalized(State state, uint256 raised);
    event Withdrawn(address indexed owner, uint256 amount);
    event Refunded(address indexed backer, uint256 amount);

    error NotOwner(address caller);
    error WrongState(State current, State expected);
    error ZeroContribution();
    error DeadlinePassed(uint64 deadline, uint256 nowTime);
    error DeadlineNotReached(uint64 deadline, uint256 nowTime);
    error NothingToRefund();
    error TransferFailed();
    error NotImplemented(string what);

    modifier onlyOwner() {
        // TODO: revert with NotOwner when the caller is not the owner
        _;
    }

    modifier inState(State expected) {
        // TODO: revert with WrongState when state differs from expected
        _;
    }

    constructor(uint256 goal_, uint64 durationSeconds) {
        owner = msg.sender;
        goal = goal_;
        deadline = uint64(block.timestamp) + durationSeconds;
        console.log("Crowdfund: goal %s wei, deadline at timestamp %s", goal_, deadline);
    }

    // TODO: reject a zero contribution and a contribution after the deadline,
    // record the amount for the backer, increase raised, log and emit
    function contribute() external payable inState(State.Open) {
        revert NotImplemented("contribute");
    }

    // TODO: only after the deadline; set state to Successful when raised
    // reaches the goal, to Failed otherwise; log and emit
    function finalize() external inState(State.Open) {
        revert NotImplemented("finalize");
    }

    // TODO: send the whole balance to the owner; log and emit
    function withdraw() external onlyOwner inState(State.Successful) {
        revert NotImplemented("withdraw");
    }

    // TODO: send the backer's contribution back, in checks-effects-interactions
    // order; log and emit. The nonReentrant lock is already applied.
    function refund() external nonReentrant inState(State.Failed) {
        revert NotImplemented("refund");
    }

    function secondsLeft() external view returns (uint256) {
        return block.timestamp >= deadline ? 0 : deadline - block.timestamp;
    }
}
