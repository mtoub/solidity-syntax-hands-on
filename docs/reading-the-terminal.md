# Reading the terminal

The terminal is the panel at the bottom of Remix. Everything a contract does shows up there in one of three forms.

## Console lines

The contracts in this repository import Hardhat's console library:

```solidity
import "hardhat/console.sol";

console.log("increment: count before", count);
console.log("quote: amount %s, fee %s, net %s", amount, fee, net);
```

Remix VM prints these lines in the terminal, in the order the code ran. They are the quickest way to follow a function step by step.

Things to know:

- `console.log` accepts up to four arguments of type `string`, `uint256`, `bool` or `address`. `%s` in the first string is replaced by the next argument.
- It only works on a local VM. On a real network the calls do nothing, and they still cost gas, so they are removed before a contract is deployed for real.
- Indented lines in this repository mean the code is running deeper in a chain of calls.

## Transaction details

Each transaction adds a line to the terminal. Click it to expand it.

| Field | What it tells you |
|---|---|
| status | succeeded, or reverted |
| from / to | who sent it, and to which contract |
| execution cost | gas used by the contract code |
| decoded input | the arguments you passed |
| decoded output | the values returned |
| logs | the events emitted |

## Events

An event is declared, then emitted:

```solidity
event Incremented(address indexed by, uint256 newCount);

emit Incremented(msg.sender, count);
```

Expand the transaction and look at **logs**: Remix shows the event name and each argument with its name.

## Console line or event?

| | `console.log` | Event |
|---|---|---|
| Purpose | Debugging while you develop | Telling applications what happened |
| Works on a real network | No | Yes |
| Stored on the blockchain | No | Yes, in the transaction's logs |
| Visible when the transaction reverts | Depends on the Remix version | No: a revert erases the events |

The last row is worth trying: `emitThenFail` in [`Events.sol`](../contracts/functions/Events.sol) emits an event and then reverts.

## Calls made with blue buttons

A blue button makes a call, not a transaction. The result appears next to the button, and the terminal shows a `call` line. There are no events, since nothing is recorded.

## Failed transactions

The terminal shows the reason for a revert:

- a text message, from `require(condition, "message")` or `revert("message")`
- a custom error with its arguments, such as `InvalidAmount(5, 10)`
- a Panic code, raised by the language itself: `0x11` for arithmetic overflow, `0x32` for an array index out of bounds
