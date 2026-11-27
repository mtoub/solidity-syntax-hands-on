# Transient storage

File: [`contracts/transient/TransientStorage.sol`](../contracts/transient/TransientStorage.sol)

## The idea

A variable marked `transient` is declared like a state variable and used like one. The difference is its lifetime: it is erased at the end of every transaction.

```solidity
uint256 public persistentCount;       // storage: kept forever
uint256 transient private txCount;    // transient: kept until the transaction ends
```

| | `storage` | `transient` |
|---|---|---|
| Lifetime | Permanent | One transaction |
| Cost of a write | Up to about 22,100 gas for a new value | About 100 gas |
| Shared between functions | Yes | Yes |
| Survives calls to and from other contracts | Yes | Yes, within the transaction |
| Value at the start of a transaction | Whatever was stored | Always the default (0, `false`) |

It was added to the EVM by EIP-1153 and needs the Cancun fork or later.

## How to run it

1. Deploy `TransientStorage`.
2. Click `bump` three times.
3. Click `bumpThreeTimes`.
4. Click `readTransient`.
5. Select `Caller` in the **Contract** list, deploy it with the address of `TransientStorage`, and click `bumpTwice`.

## What to expect

Three separate transactions:

```
bump: persistent 1, transient 1
bump: persistent 2, transient 1
bump: persistent 3, transient 1
```

One transaction calling `bump` three times:

```
bump: persistent 4, transient 1
bump: persistent 5, transient 2
bump: persistent 6, transient 3
```

`readTransient` returns 0.

One transaction from another contract:

```
Caller: first external call
bump: persistent 7, transient 1
Caller: second external call, same transaction
bump: persistent 8, transient 2
```

## What to notice

- The transient count restarts at 1 in every new transaction. Nothing had to reset it.
- Inside one transaction the value is kept, even when the contract is entered a second time from outside.

That second point is what a reentrancy lock needs: a flag that says "this contract is busy" for as long as the transaction runs, and that is guaranteed to be clear at the start of the next one. Before transient storage, the flag lived in regular storage, which cost more and had to be reset by hand.

## Rules

- Only value types can be transient (`bool`, integers, `address`...). No arrays, mappings or structs.
- A transient variable cannot be given an initial value in its declaration.
- The keyword goes after the type: `bool transient private _locked;`

## Challenge

Add a function that calls `bump()` and then returns `txCount`. Is the result 0 or 1? Why is it different from `readTransient`?

Next: [Reentrancy](reentrancy.md)
