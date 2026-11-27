# Functions

How functions are declared, who may call them, what they may do, and how they report success or failure.

## Returns

File: [`contracts/functions/Returns.sol`](../contracts/functions/Returns.sol)

**Idea.** A function declaration reads: name, inputs, visibility, mutability, outputs. A function can return several values.

```solidity
function minMax(uint256 x, uint256 y) public pure returns (uint256 min, uint256 max)
```

**How to run it**

1. Call `getMath`.
2. Call `minMax` with `7, 3`.
3. Call `useTuple`.

**What to expect**

- `getMath` returns 10 and 20.
- `minMax` returns min 3, max 7, shown with their names.
- `useTuple` returns 50: 10 + 20 + 20.

**Challenge.** Write `divide(a, b)` returning the quotient and the remainder.

## Visibility

File: [`contracts/functions/Visibility.sol`](../contracts/functions/Visibility.sol)

**Idea.** Visibility says who may call a function.

| Keyword | Outside | This contract | Child contracts |
|---|---|---|---|
| `public` | Yes | Yes | Yes |
| `external` | Yes | Only through `this.` | Only through `this.` |
| `internal` | No | Yes | Yes |
| `private` | No | Yes | No |

**How to run it**

1. Deploy `Base` and look at its buttons.
2. Call `callAllFromInside`.
3. Deploy `Derived` and call `callFromChild`.

**What to expect**

- `Base` has buttons for `pubFn`, `extFn` and `callAllFromInside` only.
- `callAllFromInside` returns "public", "external", "internal", "private".
- `callFromChild` returns "public", "internal".

**What to notice.** `private` restricts other contracts, not readers. All data on a blockchain is readable by anyone.

**Challenge.** Uncomment `privFn()` in `Derived` and read the compiler error.

## Mutability

File: [`contracts/functions/Mutability.sol`](../contracts/functions/Mutability.sol)

**Idea.** A function declares what it does with state.

| Keyword | Reads state | Writes state | Accepts ETH |
|---|---|---|---|
| `pure` | No | No | No |
| `view` | Yes | No | No |
| (none) | Yes | Yes | No |
| `payable` | Yes | Yes | Yes |

**How to run it**

1. Look at the button colours.
2. Call `twice` with `21`.
3. Call `add` with `5`, then `readTotal`.
4. Set **Value** to `1` Wei and click `pay`. Read `total`.
5. Set **Value** to `1` Wei and call `add` with `1`.

**What to expect**

- `twice` returns 42 without a transaction.
- `total` goes to 5, then 6.
- The last call reverts: a function that is not `payable` refuses ETH.

**Challenge.** Change `readTotal` from `view` to `pure` and read the compiler error.

## Modifiers

File: [`contracts/functions/Modifiers.sol`](../contracts/functions/Modifiers.sol)

**Idea.** A modifier is reusable code wrapped around a function. The placeholder `_;` is where the function body runs.

```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}

function setValue(uint256 newValue) external onlyOwner { ... }
```

**How to run it**

1. Deploy with the first account and call `setValue` with `42`.
2. Switch to the second account and call `setValue` with `1`.
3. Back on the first account, call `setValueLogged` with `7`.
4. Call `setValueLogged` with `500`.

**What to expect**

- The second account gets `Not owner`: the body never ran.
- `setValueLogged(7)` prints:

```
logged: before the body, value is 42
setValueLogged: inside the body
logged: after the body, value is  7
```

- `setValueLogged(500)` reverts with `Value too large`.

**What to notice.** Code after `_;` runs once the body has finished. The reentrancy lock in [Reentrancy](reentrancy.md) relies on exactly that.

**Challenge.** Write `notZero(uint256 x)` and apply it to `setValue`.

## Events

File: [`contracts/functions/Events.sol`](../contracts/functions/Events.sol)

**Idea.** Events are the contract's way of telling the outside world what happened. They are stored in the transaction's logs, cost far less than storage, and cannot be read back by contracts.

**How to run it**

1. Set **Value** to `1` Ether and call `sendFunds` with the second account's address.
2. Expand the transaction and open **logs**.
3. Call `leaveNote` with `"hello"` and look at its logs.
4. Call `emitThenFail` and choose **Send Transaction** on the warning.

**What to expect**

- A `Transfer` event with `from`, `to` and `amount`.
- A `Note` event with your text.
- After `emitThenFail`: a reverted transaction with no event.

**What to notice.** `indexed` fields can be searched by applications. A revert erases the events emitted earlier in the same transaction.

**Challenge.** Count the notes and include the count in the `Note` event.

## Errors

File: [`contracts/functions/Errors.sol`](../contracts/functions/Errors.sol)

**Idea.** An error reverts the whole transaction: every change made so far is undone.

| Form | Example |
|---|---|
| Check with a message | `require(x > 10, "Value too small");` |
| Fail on purpose | `revert("Too large");` |
| Custom error | `revert InvalidAmount(x, 10);` |
| Check with a custom error | `require(x >= 10, InvalidAmount(x, 10));` |

**How to run it**

1. Call `testRequire` with `5`, `500`, then `50`.
2. Call `testCustom` with `5`.
3. Call `testRequireCustom` with `5`.
4. Call `incrementThenFail`, then read `counter`.
5. Call `incrementThenSucceed`, then read `counter`.

**What to expect**

- "Value too small", "Too large", then success.
- `InvalidAmount` decoded with `sent` 5 and `min` 10.
- `counter` is 0 after the failing call, 1 after the successful one.

**What to notice.** Custom errors are cheaper than text and carry data that applications can read.

**Challenge.** Replace the "Too large" message by a custom error `TooLarge(sent, max)`.

## Inheritance

File: [`contracts/functions/Inheritance.sol`](../contracts/functions/Inheritance.sol)

**Idea.** A contract inherits with `is`. A parent marks a function `virtual` to allow replacing it; the child marks its version `override`.

**How to run it**

1. Deploy `A` and `B`, call `foo` on each.
2. Deploy `Child`, call `who`.
3. Deploy `WorldGreeter`, call `greet`.
4. Try to deploy `GreeterBase`.

**What to expect**

- "A" and "B".
- "Child > Base2".
- "Hello, world".
- Remix refuses to deploy the abstract `GreeterBase`.

**What to notice.** With several parents, `super` follows the order of the `is` list from right to left. `Child is Base1, Base2` reaches `Base2` first.

**Challenge.** Swap the parents to `Child is Base2, Base1`. What does `who` return?

Next: [Transient storage](transient-storage.md)
