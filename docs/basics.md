# Basics

Three contracts to get comfortable with Remix and with the shape of a Solidity file.

## HelloLogs

File: [`contracts/basics/HelloLogs.sol`](../contracts/basics/HelloLogs.sol)

**Idea.** Before any syntax, learn to see what a contract is doing. This contract only logs: once with `console.log`, once with an event.

**How to run it**

1. Compile and deploy `HelloLogs`. The terminal prints `HelloLogs deployed by` followed by your address.
2. Call `sayHello` with `"hi"`.
3. Expand the transaction in the terminal and open **logs**.
4. Click `whoAmI`.

**What to expect**

```
sayHello called by 0x5B38...
message: hi
```

and, in **logs**, a `Hello` event with `from` and `message`.

**What to notice.** `sayHello` has an orange button and creates a transaction. `whoAmI` has a blue button and creates none.

**Challenge.** Add `logNumber(uint256 n)` that prints `n` and `n * 2` with a single `console.log`.

## Counter

File: [`contracts/basics/Counter.sol`](../contracts/basics/Counter.sol)

**Idea.** The parts of a contract: the pragma line, a state variable, a constructor and a function.

**How to run it**

1. Type `5` next to **Deploy**, then deploy.
2. Click `count`: it returns 5.
3. Click `increment`, then `count` again: 6.
4. Deploy a second instance with `100`.

**What to expect**

```
Counter deployed, initial count: 5
increment: count before 5
increment: count after  6
```

**What to notice**

- You never wrote a `count()` function. The word `public` on the state variable generated it.
- `increment` cost gas, reading `count` did not.
- The two instances have separate addresses and separate counts.

**Challenge.** Add `decrement()` with its own event. Call it when the count is 0 and read the error.

## ContractTypes

File: [`contracts/basics/ContractTypes.sol`](../contracts/basics/ContractTypes.sol)

**Idea.** Solidity has four contract-level building blocks.

| Kind | What it is | Deployable |
|---|---|---|
| `interface` | Function signatures only | No |
| `library` | Reusable code without state | Not needed here: its code is copied in |
| `abstract contract` | Partly implemented | No |
| `contract` | Complete | Yes |

**How to run it**

1. Select `FeeCalculator` in the **Contract** list and deploy it with `25` (25 basis points, 0.25%).
2. Call `quote` with `1000000`.
3. Select `FeeBase` in the **Contract** list and try to deploy it.

**What to expect**

- `quote` returns fee `2500` and net `997500`: 1,000,000 × 25 / 10,000 = 2,500.
- Remix refuses to deploy `FeeBase`, because it is abstract.

**What to notice.** `FeeCalculator` only contains a constructor and one small function. Everything else comes from `FeeBase` and `FeeMath`.

**Challenge.** Add `FlatFeeCalculator is IFeeQuote`, charging a fixed fee whatever the amount.

Next: [Types](types.md)
