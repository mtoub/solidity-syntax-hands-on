# Capstone: a crowdfunding campaign

File: [`contracts/capstone/Crowdfund.sol`](../contracts/capstone/Crowdfund.sol)

Solution: [`contracts/solutions/CrowdfundSolution.sol`](../contracts/solutions/CrowdfundSolution.sol)

A campaign collects ETH until a deadline. If the goal is reached, the owner takes the funds. If not, every backer can take their money back.

The file gives you the declarations: the enum, the struct, the state variables, the events and the errors. The modifiers and four functions are left for you, marked `TODO`. The file compiles as it is, so you can deploy and test after each step.

While the bodies are missing, the compiler shows a few warnings about unreachable code and state mutability. They disappear as you fill the functions in.

## What it uses

| Concept | Where |
|---|---|
| Enum | `State { Open, Successful, Failed }` |
| Struct and mapping | `Backer`, `backers` |
| `immutable` | `owner`, `goal`, `deadline` |
| Modifiers with and without arguments | `onlyOwner`, `inState` |
| Custom errors | every failure case |
| Events and console lines | every state change |
| `payable` and `call` | `contribute`, `withdraw`, `refund` |
| Reentrancy lock | `refund` uses `nonReentrant` |

## Expected behaviour

**`onlyOwner`**: reverts with `NotOwner(caller)` unless the caller is the owner.

**`inState(expected)`**: reverts with `WrongState(current, expected)` unless `state` equals `expected`.

**`contribute()`**, payable, while `Open`:

- reverts with `ZeroContribution` when no ETH is sent
- reverts with `DeadlinePassed` once `block.timestamp` has reached `deadline`
- adds the amount to the backer's record and to `raised`
- emits `Contributed`

**`finalize()`**, while `Open`, callable by anyone:

- reverts with `DeadlineNotReached` before the deadline
- sets `state` to `Successful` when `raised >= goal`, to `Failed` otherwise
- emits `Finalized`

**`withdraw()`**, owner only, while `Successful`:

- sends the whole balance to the owner, reverting with `TransferFailed` if the send fails
- emits `Withdrawn`

**`refund()`**, while `Failed`:

- reverts with `NothingToRefund` when the caller has no contribution
- sets the caller's amount to 0, then sends it back (checks, effects, interactions)
- emits `Refunded`

## Suggested order

1. The two modifiers.
2. `contribute`.
3. `finalize`.
4. `withdraw`.
5. `refund`.

Add a `console.log` in each function so you can follow it in the terminal.

## How to test it

The constructor takes the goal in wei and a duration in seconds. A short duration lets you reach the deadline quickly.

**A failed campaign**

1. Deploy with `5000000000000000000, 60`: a goal of 5 ETH, open for 60 seconds.
2. Second account: set **Value** to `2` Ether, click `contribute`. Read `raised` and `backers` with the second account's address.
3. Click `finalize` straight away: `DeadlineNotReached`.
4. Click `secondsLeft` until it returns 0, then `finalize`. `state` returns 2 (`Failed`).
5. First account: `withdraw` reverts with `WrongState`.
6. Second account: `refund`. The 2 ETH come back. A second `refund` reverts with `NothingToRefund`.

**A successful campaign**

1. Deploy again with `5000000000000000000, 60`.
2. Second account contributes 3 ETH, third account contributes 2 ETH.
3. After the deadline, `finalize`. `state` returns 1 (`Successful`).
4. Second account: `withdraw` reverts with `NotOwner`.
5. First account: `withdraw`. The contract balance goes to 0.

Note: Remix VM only moves time forward when a transaction is mined. If `secondsLeft` seems stuck, send any transaction and read it again.

## Going further

- Let the owner cancel the campaign while it is open.
- Reject contributions that would exceed the goal.
- Attack your `refund` with a contract modelled on `Attacker.sol`, with and without the lock.
