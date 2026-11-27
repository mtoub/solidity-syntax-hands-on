# Solidity syntax hands-on

A set of small Solidity contracts to learn the language by running it. Each contract shows one concept, prints what it is doing to the terminal, and ends with a short challenge.

Everything runs in [Remix IDE](https://remix.ethereum.org) on Remix VM, a simulated blockchain inside the browser. There is nothing to install, no wallet and no test network.

- Solidity `^0.8.30`
- Remix VM, Cancun fork or later (the default is fine)

## Start here

1. [Getting started](docs/getting-started.md): load this repository into Remix and set up the compiler.
2. [Remix cheat sheet](docs/remix-cheat-sheet.md): buttons, input formats, accounts.
3. [Reading the terminal](docs/reading-the-terminal.md): how to see what a contract did.

## Learning path

Follow the contracts from top to bottom. Each guide gives, for every contract, the idea, the steps to run it, what to expect and a challenge.

| Topic | Contract | Guide |
|---|---|---|
| Seeing what a contract does | [`HelloLogs.sol`](contracts/basics/HelloLogs.sol) | [Basics](docs/basics.md#hellologs) |
| Anatomy of a contract | [`Counter.sol`](contracts/basics/Counter.sol) | [Basics](docs/basics.md#counter) |
| Interface, library, abstract contract, contract | [`ContractTypes.sol`](contracts/basics/ContractTypes.sol) | [Basics](docs/basics.md#contracttypes) |
| Value types | [`ValueTypes.sol`](contracts/types/ValueTypes.sol) | [Types](docs/types.md#valuetypes) |
| Checked arithmetic | [`Overflow.sol`](contracts/types/Overflow.sol) | [Types](docs/types.md#overflow) |
| Storage slots and packing | [`Packing.sol`](contracts/types/Packing.sol) | [Types](docs/types.md#packing) |
| The address type | [`Addresses.sol`](contracts/types/Addresses.sol) | [Types](docs/types.md#addresses) |
| Receiving and sending ETH | [`Payments.sol`](contracts/types/Payments.sol) | [Types](docs/types.md#payments) |
| Arrays | [`Arrays.sol`](contracts/types/Arrays.sol) | [Types](docs/types.md#arrays) |
| Strings and bytes | [`StringsAndBytes.sol`](contracts/types/StringsAndBytes.sol) | [Types](docs/types.md#stringsandbytes) |
| Structs | [`Structs.sol`](contracts/types/Structs.sol) | [Types](docs/types.md#structs) |
| Mappings | [`Mappings.sol`](contracts/types/Mappings.sol) | [Types](docs/types.md#mappings) |
| Storage, memory, calldata | [`DataLocation.sol`](contracts/types/DataLocation.sol) | [Types](docs/types.md#datalocation) |
| Return values | [`Returns.sol`](contracts/functions/Returns.sol) | [Functions](docs/functions.md#returns) |
| Visibility | [`Visibility.sol`](contracts/functions/Visibility.sol) | [Functions](docs/functions.md#visibility) |
| View, pure, payable | [`Mutability.sol`](contracts/functions/Mutability.sol) | [Functions](docs/functions.md#mutability) |
| Modifiers | [`Modifiers.sol`](contracts/functions/Modifiers.sol) | [Functions](docs/functions.md#modifiers) |
| Events | [`Events.sol`](contracts/functions/Events.sol) | [Functions](docs/functions.md#events) |
| Errors and reverts | [`Errors.sol`](contracts/functions/Errors.sol) | [Functions](docs/functions.md#errors) |
| Inheritance | [`Inheritance.sol`](contracts/functions/Inheritance.sol) | [Functions](docs/functions.md#inheritance) |
| Transient storage | [`TransientStorage.sol`](contracts/transient/TransientStorage.sol) | [Transient storage](docs/transient-storage.md) |
| Reentrancy: the attack and two fixes | [`contracts/reentrancy/`](contracts/reentrancy) | [Reentrancy](docs/reentrancy.md) |
| Capstone: a crowdfunding campaign | [`Crowdfund.sol`](contracts/capstone/Crowdfund.sol) | [Capstone](docs/capstone.md) |

## How logging works here

A contract cannot print to a screen. These contracts use two tools to show what happens inside them:

- **`console.log`**, imported from `hardhat/console.sol`. Remix VM prints these lines in the terminal as the function runs. It is a development aid that only works on a local VM.
- **Events**, the mechanism real contracts use. They are stored with the transaction and appear, decoded, in the `logs` field when you expand a transaction in the terminal.

[Reading the terminal](docs/reading-the-terminal.md) explains both.

## Reference

- [Challenge answers](docs/challenge-answers.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Glossary](docs/glossary.md)

## A word of caution

These contracts are written to teach, not to be used with real funds. Several of them are vulnerable on purpose.

## License

MIT
