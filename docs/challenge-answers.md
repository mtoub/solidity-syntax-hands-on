# Challenge answers

One possible answer for each challenge. Try first, then compare.

## Basics

**HelloLogs**

```solidity
function logNumber(uint256 n) external pure {
    console.log("n is %s, twice n is %s", n, n * 2);
}
```

**Counter**

```solidity
event Decremented(address indexed by, uint256 newCount);

function decrement() public {
    count -= 1;
    emit Decremented(msg.sender, count);
}
```

At 0 the subtraction reverts with Panic `0x11`: an unsigned integer cannot go below zero.

**ContractTypes**

```solidity
contract FlatFeeCalculator is IFeeQuote {
    uint256 private immutable flatFee;

    constructor(uint256 flatFee_) {
        flatFee = flatFee_;
    }

    function quote(uint256 amount) external view returns (uint256 fee, uint256 net) {
        fee = flatFee;
        net = amount - fee;
    }
}
```

## Types

**ValueTypes**

```solidity
int256 public signedValue;

function subtract(int256 x) external {
    signedValue -= x;
}
```

A signed integer goes below zero without any error. A `uint8` at 0 would revert.

**Overflow**

```solidity
function subOneChecked() public {
    small -= 1;
}
```

Panic `0x11` again: the code covers both overflow and underflow.

**Packing**

`uint64`, `uint256`, `uint64` uses three slots: the `uint256` fills a slot by itself and separates the two small fields. `uint64`, `uint64`, `uint256` uses two.

**Addresses**

```solidity
function myBalance() external view returns (uint256) {
    return msg.sender.balance;
}
```

**Payments**

```solidity
function withdrawAll() external {
    require(msg.sender == owner, "Not owner");
    uint256 amount = address(this).balance;
    (bool ok, ) = owner.call{value: amount}("");
    require(ok, "Payment failed");
    emit Paid(owner, amount, "call");
}
```

**Arrays**

```solidity
function sum() external view returns (uint256 total) {
    for (uint256 i = 0; i < dynArr.length; i++) {
        total += dynArr[i];
    }
}
```

**StringsAndBytes**

```solidity
function setShortLabel(bytes32 newLabel) external {
    shortLabel = newLabel;
}
```

Remix expects `0x` followed by 64 hexadecimal characters. "hi" is `0x6869000000000000000000000000000000000000000000000000000000000000`.

**Structs**

```solidity
function birthday(uint256 index) external {
    Student storage s = students[index];
    s.age += 1;
}
```

With `memory` instead of `storage`, the age would change on a copy and the stored student would stay the same.

**Mappings**

```solidity
mapping(address => mapping(address => uint256)) public allowance;

function approve(address spender, uint256 amount) external {
    allowance[msg.sender][spender] = amount;
}
```

**DataLocation**

The compiler answers: "Calldata arrays are read-only."

## Functions

**Returns**

```solidity
function divide(uint256 a, uint256 b) public pure returns (uint256 quotient, uint256 remainder) {
    quotient = a / b;
    remainder = a % b;
}
```

**Visibility**

The compiler answers: "Undeclared identifier." For `Derived`, `privFn` does not exist.

**Mutability**

The compiler refuses: a `pure` function may not read `total`, and the message suggests `view`.

**Modifiers**

```solidity
modifier notZero(uint256 x) {
    require(x != 0, "Zero not allowed");
    _;
}

function setValue(uint256 newValue) external onlyOwner notZero(newValue) {
    value = newValue;
    emit ValueChanged(msg.sender, newValue);
}
```

**Events**

```solidity
uint256 public noteCount;
event Note(uint256 indexed number, string text);

function leaveNote(string calldata text) external {
    noteCount += 1;
    emit Note(noteCount, text);
}
```

The other `emit Note(...)` in the file needs the extra argument too.

**Errors**

```solidity
error TooLarge(uint256 sent, uint256 max);

function testRequire(uint256 x) public pure {
    require(x > 10, "Value too small");
    if (x > 100) {
        revert TooLarge(x, 100);
    }
}
```

**Inheritance**

"Child > Base1". `super` follows the `is` list from right to left, and `Base1` is now the last parent.

## Transient storage

```solidity
function bumpAndRead() external returns (uint256) {
    bump();
    return txCount;
}
```

It returns 1: the read happens in the same transaction as the write. `readTransient` runs in a call of its own, which starts with clean transient storage.

## Reentrancy

Without `_locked = false;`, `BatchUser` fails on its second `withdraw` with `ReentrantCall`. The lock would only clear at the end of the transaction, so a contract could use the vault once per transaction at most.

## Capstone

See [`contracts/solutions/CrowdfundSolution.sol`](../contracts/solutions/CrowdfundSolution.sol).
