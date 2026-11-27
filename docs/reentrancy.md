# Reentrancy

Folder: [`contracts/reentrancy/`](../contracts/reentrancy)

| File | Role |
|---|---|
| [`IVault.sol`](../contracts/reentrancy/IVault.sol) | The interface shared by the vaults: `deposit` and `withdraw` |
| [`VulnerableVault.sol`](../contracts/reentrancy/VulnerableVault.sol) | A vault with the bug |
| [`Attacker.sol`](../contracts/reentrancy/Attacker.sol) | A contract that exploits it |
| [`ReentrancyGuard.sol`](../contracts/reentrancy/ReentrancyGuard.sol) | The `nonReentrant` modifier, built on transient storage |
| [`GuardedVault.sol`](../contracts/reentrancy/GuardedVault.sol) | The same vault, protected by the modifier |
| [`SafeOrderVault.sol`](../contracts/reentrancy/SafeOrderVault.sol) | The same vault, fixed by reordering its code |
| [`BatchUser.sol`](../contracts/reentrancy/BatchUser.sol) | An honest user, to check the lock is not too strict |

Read [Modifiers](functions.md#modifiers) and [Transient storage](transient-storage.md) first.

## What reentrancy is

When a contract sends ETH to another contract, the receiver's code runs. While it runs, the sender is paused in the middle of its function. If the receiver uses that moment to call the sender again, it *re-enters* a function that has not finished.

That is harmless if the sender's records were already up to date. It is a disaster if they were not.

## The bug

```solidity
function withdraw() external {
    uint256 amount = balances[msg.sender];
    require(amount > 0, "Nothing to withdraw");

    (bool ok, ) = msg.sender.call{value: amount}("");   // sends the ETH
    require(ok, "Transfer failed");

    balances[msg.sender] = 0;                           // updates the books, too late
}
```

Between the send and the update, the vault still believes the caller owns `amount`.

## How the attack works

The attacker is a contract with a `receive` function, which runs every time it gets ETH:

```solidity
receive() external payable {
    if (address(vault).balance >= 1 ether) {
        vault.withdraw();
    }
}
```

The attacker deposits 1 ETH and calls `withdraw`. Each line below is one level deeper in the same transaction:

```
Attacker.attack
└─ Vault.withdraw                   record says 1 ETH, sends 1 ETH
   └─ Attacker.receive              calls withdraw again
      └─ Vault.withdraw             record STILL says 1 ETH, sends 1 ETH
         └─ Attacker.receive        calls withdraw again
            └─ Vault.withdraw       record STILL says 1 ETH, sends 1 ETH
               └─ ...               until the vault is empty
```

Only when the vault is empty do the calls return, one by one, and each `withdraw` finally sets the balance to 0. By then the money is gone.

## Run the attack

Use three accounts: the first deploys the vault, the second is the victim, the third is the attacker.

1. First account: deploy `VulnerableVault`.
2. Second account: set **Value** to `10` Ether and click `deposit`. `totalHeld` returns 10 ETH in wei.
3. Third account: select `Attacker` in the **Contract** list. In the field next to **Deploy**, paste the vault's address, add `, false`, then deploy. The field then reads like `0xd914...9138, false`.
4. Third account: set **Value** to `1` Ether and click `attack`.
5. Read `totalHeld` on the vault and `depth` on the attacker.
6. Click `collect` to move the ETH to the third account.

**What to expect in the terminal**

```
Attacker.attack: depositing 1 ether, then withdrawing
Vault.deposit: 1000000000000000000 wei from 0x...
Vault.withdraw: balance on record 1000000000000000000, vault holds 11000000000000000000
  Attacker.receive: depth 1, got 1000000000000000000 wei, vault holds 10000000000000000000
Vault.withdraw: balance on record 1000000000000000000, vault holds 10000000000000000000
  Attacker.receive: depth 2, got 1000000000000000000 wei, vault holds 9000000000000000000
...
  Attacker.receive: depth 11, got 1000000000000000000 wei, vault holds 0
Vault.withdraw: balance set to 0, vault holds 0
... (eleven times)
Attacker.attack: done, attacker holds 11000000000000000000 wei
```

**What to notice**

- "balance on record" is 1 ETH on every line. The vault never noticed it had already paid.
- The eleven "balance set to 0" lines all come at the end, when the calls unwind.
- The vault holds 0. The attacker put in 1 ETH and holds 11: the victim's 10 ETH are gone.
- In **logs**, eleven `Withdrawn` events for one deposit.

## Fix with a lock: the `nonReentrant` modifier

```solidity
abstract contract ReentrancyGuard {
    error ReentrantCall();

    bool transient private _locked;

    modifier nonReentrant() {
        if (_locked) revert ReentrantCall();   // already inside? refuse
        _locked = true;                        // take the lock
        _;                                     // run the function body
        _locked = false;                       // release the lock
    }
}
```

`GuardedVault` inherits from it and adds one word:

```solidity
function withdraw() external nonReentrant {
```

The body of `withdraw` is unchanged, still in the unsafe order, to show that the modifier alone stops the attack.

**Line by line**

| Line | During the first `withdraw` | During the re-entrant `withdraw` |
|---|---|---|
| `if (_locked) revert` | `_locked` is `false`: continue | `_locked` is `true`: revert |
| `_locked = true` | Lock taken | Not reached |
| `_;` | Body runs and sends ETH, which triggers the attacker | Not reached |
| `_locked = false` | Lock released when the body is done | Not reached |

**Why transient storage**

- The lock has to be visible to the re-entrant call. A local variable would not be: each call gets its own. Transient storage is shared by every call into the contract during the transaction.
- The lock is only meaningful while the transaction runs. Transient storage is erased when it ends, so the lock cannot stay stuck.
- It is cheap: about 100 gas to read or write, where a regular storage write costs thousands.

### Run it

1. First account: deploy `GuardedVault`.
2. Second account: deposit `10` Ether.
3. Third account: deploy a new `Attacker` with the `GuardedVault` address and `true`.
4. Third account: set **Value** to `1` Ether and click `attack`.
5. Read `totalHeld` on the vault and `depth` on the attacker.

**What to expect in the terminal**

```
Attacker.attack: depositing 1 ether, then withdrawing
Vault.deposit: 1000000000000000000 wei from 0x...
    nonReentrant: lock taken
Vault.withdraw: balance on record 1000000000000000000, vault holds 11000000000000000000
  Attacker.receive: depth 1, got 1000000000000000000 wei, vault holds 10000000000000000000
    nonReentrant: lock already taken, rejecting the call
  Attacker.receive: re-entry was blocked
Vault.withdraw: balance set to 0, vault holds 10000000000000000000
    nonReentrant: lock released
Attacker.attack: done, attacker holds 1000000000000000000 wei
```

The vault still holds 10 ETH. The attacker got back its own 1 ETH and nothing more. **logs** contains a `ReentryBlocked` event.

### The `true` and `false` flag of the attacker

The second constructor argument of `Attacker` decides what happens when a re-entry is refused.

| Flag | Behaviour | Result against `GuardedVault` |
|---|---|---|
| `true` | The attacker catches the failure with `try` / `catch` and carries on | The transaction succeeds; logs and events show the blocked attempt |
| `false` | The failure propagates | `receive` reverts, the vault's send fails, the whole transaction reverts with `Transfer failed`; nothing changes anywhere |

Try both. With `false`, Remix shows the gas estimation warning: choose **Send Transaction**. Either way the vault keeps its 10 ETH.

## Fix by reordering: checks, effects, interactions

`SafeOrderVault` has no lock. It writes the function in a safe order:

```solidity
function withdraw() external {
    uint256 amount = balances[msg.sender];
    require(amount > 0, "Nothing to withdraw");          // checks

    balances[msg.sender] = 0;                            // effects

    (bool ok, ) = msg.sender.call{value: amount}("");    // interactions
    require(ok, "Transfer failed");
}
```

When the attacker re-enters, the record already says 0 and the check fails.

### Run it

Repeat the previous steps with `SafeOrderVault` and an `Attacker` deployed with `true`.

```
Vault.withdraw: balance on record 1000000000000000000, vault holds 11000000000000000000
  Attacker.receive: depth 1, got 1000000000000000000 wei, vault holds 10000000000000000000
Vault.withdraw: balance on record 0, vault holds 10000000000000000000
  Attacker.receive: re-entry was blocked
```

## Which fix to use

Both. Checks-effects-interactions is a habit to apply to every function that sends ETH or calls another contract. The lock is a safety net for the cases where the order is hard to get right, for example when several functions share the same state.

## Exercise: why the lock must be released

`BatchUser` deposits and withdraws twice in one transaction. The second `withdraw` starts after the first has finished, so it is not reentrancy.

1. Deploy `GuardedVault`, then `BatchUser` with its address.
2. Set **Value** to `2` Ether and click `depositAndWithdrawTwice`. It succeeds: the console shows the lock taken and released twice.
3. In `ReentrancyGuard.sol`, comment out `_locked = false;` and the console line after it. Compile.
4. Deploy a new `GuardedVault` and a new `BatchUser`, and run the same call.

It now reverts. The lock taken by the first `withdraw` is still set when the second one starts, because transient storage is only erased at the end of the transaction. An honest user is locked out.

Put the line back when you are done.

## Summary

- Sending ETH to a contract runs its code. Assume that code is hostile.
- Update your own state before calling out.
- Add a `nonReentrant` lock to functions that call out.
- A transient variable is the natural home for the lock: shared across calls, erased at the end of the transaction, cheap.

Next: [Capstone](capstone.md)
