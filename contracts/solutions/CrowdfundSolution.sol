// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";
import "../reentrancy/ReentrancyGuard.sol";

// A complete version of the capstone in contracts/capstone/Crowdfund.sol.
//
// A campaign collects ETH until a deadline. If the goal is reached, the
// owner takes the funds. If not, every backer can take their money back.
contract CrowdfundSolution is ReentrancyGuard {
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

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner(msg.sender);
        _;
    }

    modifier inState(State expected) {
        if (state != expected) revert WrongState(state, expected);
        _;
    }

    constructor(uint256 goal_, uint64 durationSeconds) {
        owner = msg.sender;
        goal = goal_;
        deadline = uint64(block.timestamp) + durationSeconds;
        console.log("Crowdfund: goal %s wei, deadline at timestamp %s", goal_, deadline);
    }

    function contribute() external payable inState(State.Open) {
        if (msg.value == 0) revert ZeroContribution();
        if (block.timestamp >= deadline) revert DeadlinePassed(deadline, block.timestamp);

        Backer storage b = backers[msg.sender];
        b.amount += msg.value;
        b.lastContributionAt = uint64(block.timestamp);
        raised += msg.value;

        console.log("contribute: %s wei from %s, raised %s", msg.value, msg.sender, raised);
        emit Contributed(msg.sender, msg.value, raised);
    }

    // Anyone may close the campaign once the deadline has passed
    function finalize() external inState(State.Open) {
        if (block.timestamp < deadline) revert DeadlineNotReached(deadline, block.timestamp);

        state = raised >= goal ? State.Successful : State.Failed;

        console.log("finalize: raised %s of %s, state is now %s", raised, goal, uint256(state));
        emit Finalized(state, raised);
    }

    function withdraw() external onlyOwner inState(State.Successful) {
        uint256 amount = address(this).balance;
        (bool ok, ) = owner.call{value: amount}("");
        if (!ok) revert TransferFailed();

        console.log("withdraw: %s wei sent to the owner", amount);
        emit Withdrawn(owner, amount);
    }

    // Guarded by the lock and written in checks-effects-interactions order
    function refund() external nonReentrant inState(State.Failed) {
        Backer storage b = backers[msg.sender];
        uint256 amount = b.amount;
        if (amount == 0) revert NothingToRefund();

        b.amount = 0;

        (bool ok, ) = msg.sender.call{value: amount}("");
        if (!ok) revert TransferFailed();

        console.log("refund: %s wei returned to %s", amount, msg.sender);
        emit Refunded(msg.sender, amount);
    }

    function secondsLeft() external view returns (uint256) {
        return block.timestamp >= deadline ? 0 : deadline - block.timestamp;
    }
}
