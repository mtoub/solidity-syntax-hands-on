# Remix cheat sheet

## Function buttons

| Colour | Kind of function | What clicking does |
|---|---|---|
| Blue | `view` or `pure` | A call: reads only, no transaction, no gas paid |
| Orange | changes state | Sends a transaction |
| Red | `payable` | Sends a transaction that can carry ETH |

## Input formats

| Type | Example |
|---|---|
| Number | `42` |
| Amount of ETH | in wei: `1000000000000000000` is 1 ether |
| String | `"hello"` |
| Address | `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` |
| Boolean | `true` or `false` |
| Array | `[10,20,30]` |
| Enum | its position: `0`, `1`, `2` |
| bytes32 | `0x` followed by 64 hexadecimal characters |
| Several arguments | separated by commas: `"Alice", 22` |

Click the small arrow next to a function to get one input field per argument.

## Sending ETH with a call

1. Type the amount in **Value** and choose the unit (Wei, Gwei, Ether).
2. Click a red button.

**Value** goes back to 0 after each transaction, so set it again every time.

## Accounts

- The **Account** list holds pre-funded test accounts.
- Change the selected account to act as a different user.
- Use the copy icon next to the list to copy the selected address.

## Deployed contracts

- Each deployed instance appears under **Deployed Contracts** with its address and ETH balance.
- The copy icon copies the contract's address.
- The bin icon removes it from the list (the contract still exists on the VM).

## Transactions that revert

When a transaction is going to fail, Remix warns that gas estimation failed. Choose **Send Transaction** to run it anyway and read the reason in the terminal. Several exercises fail on purpose.

## Starting over

Changing the environment, or reloading the page, resets Remix VM: all deployed contracts and balances are gone. Your files stay.
