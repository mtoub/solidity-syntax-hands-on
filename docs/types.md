# Types

How Solidity represents data, and where that data lives. One contract per idea.

## ValueTypes

File: [`contracts/types/ValueTypes.sol`](../contracts/types/ValueTypes.sol)

**Idea.** Value types hold their data directly: `bool`, integers of a chosen size, `address` and `enum`.

**How to run it**

1. Deploy, then click `flag`, `maxUint256`, `minInt256`, `small`, `deployer`, `color` and `ONE_ETHER_IN_WEI`.
2. Call `limits`.
3. Call `setColor` with `2`, then read `color`.
4. Call `setColor` with `7`.

**What to expect**

- `limits` returns 255, -128, 127.
- `color` goes from 0 (Red) to 2 (Blue).
- `setColor(7)` reverts: 7 is not a member of the enum.

**What to notice.** You choose the size of an integer (`uint8`, `uint64`, `uint256`...). Smaller sizes matter for storage cost, shown in [Packing](#packing).

**Challenge.** Add an `int256` state variable and a function that subtracts from it until it goes below zero.

## Overflow

File: [`contracts/types/Overflow.sol`](../contracts/types/Overflow.sol)

**Idea.** Arithmetic is checked. Exceeding the range of a type reverts the transaction instead of silently wrapping around.

**How to run it**

1. Read `small`: 255, the maximum for `uint8`.
2. Click `addOneChecked` and choose **Send Transaction** on the warning.
3. Read `small` again.
4. Click `addOneUnchecked`, then read `small`.

**What to expect**

- The checked call reverts with a Panic, code `0x11`. `small` is still 255.
- The unchecked call succeeds and prints `addOneUnchecked: 255 became 0`.

**What to notice.** The second console line of `addOneChecked` never prints: the function stopped at the addition.

**Challenge.** Add `subOneChecked()` and call it when `small` is 0.

## Packing

File: [`contracts/types/Packing.sol`](../contracts/types/Packing.sol)

**Idea.** Storage is a series of 32-byte slots. Writing a new slot is the most expensive common operation. Small variables declared next to each other share a slot.

**How to run it**

1. Deploy `Unpacked` and `Packed`.
2. Call `store` with `1, 2, 3` on each, once.
3. Compare **execution cost** in the two transactions.

**What to expect**

| Contract | Storage work on the first call | Gas for storage |
|---|---|---|
| `Unpacked` | 3 new slots × 22,100 | 66,300 |
| `Packed` | 1 new slot (22,100), then 2 cheap updates of the same slot | about 22,800 |

`Packed` is about 43,500 gas cheaper. The exact figures can vary slightly with the compiler settings; the gap is what matters.

**What to notice.** This file has no `console.log`, so the numbers stay clean.

**Challenge.** Declare `uint64`, `uint256`, `uint64` in that order. How many slots? Reorder to use fewer.

## Addresses

File: [`contracts/types/Addresses.sol`](../contracts/types/Addresses.sol)

**Idea.** An `address` is a 20-byte identifier for a user account or a contract.

**How to run it**

1. Deploy and read `owner`.
2. Copy another account's address and call `balanceOf` with it.
3. Call `isContract` with a user address, then with the address of the deployed contract.
4. Switch account and call `whoIsCalling`.

**What to expect**

- `balanceOf` returns `100000000000000000000`: 100 ETH in wei.
- `isContract` is `false` for a user and `true` for the contract.
- `whoIsCalling` returns the selected account and `false`.

**What to notice.** `msg.sender` changes with the account that sends the call. `owner` was fixed at deployment.

**Challenge.** Add a function returning the balance of whoever calls it.

## Payments

File: [`contracts/types/Payments.sol`](../contracts/types/Payments.sol)

**Idea.** A function must be `payable` to receive ETH. A contract sends ETH with `call{value: ...}`.

**How to run it**

1. Deploy with the first account.
2. Set **Value** to `2` Ether and click `deposit`. Read `contractBalance`.
3. Call `payWithCall` with the second account's address and `1000000000000000000`.
4. Call `payWithTransfer` with the third account's address and `500000000000000000`.
5. Switch to the second account and call `payWithCall` again.

**What to expect**

- After the deposit: 2 ETH in the contract.
- After the two payments: 0.5 ETH left; the second account shows about 101 ETH, the third 100.5.
- The last call reverts with `Not owner`.

**What to notice.** `call` returns a success flag that the code must check. `transfer` is the older style and forwards very little gas; prefer `call`.

**Challenge.** Add `withdrawAll()` sending the whole balance to the owner.

## Arrays

File: [`contracts/types/Arrays.sol`](../contracts/types/Arrays.sol)

**Idea.** Fixed arrays have a size known at compile time. Dynamic arrays grow and shrink.

**How to run it**

1. `setFixed` with `2, 42`, then `fixedArr` with `2`.
2. `setFixed` with `5, 1`.
3. `push` with `10`, `push` with `20`, then `length`.
4. `pop`, then `length` and `getAll`.

**What to expect**

- `fixedArr(2)` returns 42.
- `setFixed(5, 1)` reverts with Panic `0x32`: valid indexes are 0 to 4.
- Length goes 2, then 1. `getAll` returns `[10]`.

**Challenge.** Add `sum()` looping over `dynArr`.

## StringsAndBytes

File: [`contracts/types/StringsAndBytes.sol`](../contracts/types/StringsAndBytes.sol)

**Idea.** `string` holds text of any length. `bytes32` holds exactly 32 bytes and is much cheaper for short labels.

**How to run it**

1. Read `label` and `shortLabel`.
2. Call `setLabel` with `"hello"`, then `labelLength`.
3. Call `join` with `"Hello, ", "world"`.
4. Call `sameText` with `"abc", "abc"`, then `"abc", "abd"`.

**What to expect**

- `label` shows text; `shortLabel` shows hexadecimal padded with zeros.
- `labelLength` returns 5.
- `sameText` returns `true`, then `false`.

**What to notice.** Strings have no `length` and no `==`. Convert to `bytes` to measure, compare hashes to test equality.

**Challenge.** Add `setShortLabel(bytes32)`. What must you type in Remix to call it?

## Structs

File: [`contracts/types/Structs.sol`](../contracts/types/Structs.sol)

**Idea.** A struct groups fields into one record.

**How to run it**

1. Call `addStudent` with `"Alice", 22`.
2. Call `students` with `0`, then `studentCount`.
3. Switch account, add `"Bob", 30`, then call `getStudent` with `1`.

**What to expect.** Each student shows the name, the age and the address of the account that added it.

**Challenge.** Add `birthday(uint256 index)` increasing a student's age by one.

## Mappings

File: [`contracts/types/Mappings.sol`](../contracts/types/Mappings.sol)

**Idea.** A mapping gives direct access to a value from a key. Every key exists from the start with a default value, and a mapping cannot be looped over.

**How to run it**

1. Call `balances` with any address.
2. From the first account, `update` with `500`. From the second, `update` with `250`.
3. Call `accountCount` and `total`.

**What to expect**

- 0 for an address never written.
- `accountCount` 2, `total` 750.

**What to notice.** To compute the total, the contract keeps a separate array of the keys it has seen.

**Challenge.** Add a nested mapping `allowance` and an `approve(address spender, uint256 amount)` function.

## DataLocation

File: [`contracts/types/DataLocation.sol`](../contracts/types/DataLocation.sol)

**Idea.** Arrays, strings and structs need a location keyword.

| Location | Lifetime | Typical use |
|---|---|---|
| `storage` | Permanent | State variables, and references to them |
| `memory` | The current call | Temporary copies |
| `calldata` | The current call, read-only | Inputs of external functions |
| `transient` | The current transaction | Short-lived flags, see [Transient storage](transient-storage.md) |

**How to run it**

1. Read `stored`: 100, "EUR".
2. Call `updateViaMemory` with `999`, then read `stored`.
3. Call `updateViaStorage` with `250`, then read `stored`.
4. Call `sumCalldata` with `[10,20,30]` and `doubleFirst` with `[10,20,30]`.

**What to expect**

- `updateViaMemory` returns 999 for the copy and 100 for the state. `stored` is unchanged.
- After `updateViaStorage`, `stored` shows 250.
- `sumCalldata` returns 60, `doubleFirst` returns `[20,20,30]`.

**What to notice.** `Payment memory p = stored;` copies. `Payment storage p = stored;` points at the original.

**Challenge.** Uncomment the line in `sumCalldata` and read the compiler error.

Next: [Functions](functions.md)
