# Glossary

| Term | Meaning |
|---|---|
| ABI | Application Binary Interface: the description of a contract's functions and events that tools use to talk to it |
| Account | An address that holds ETH. Either a user account, controlled by a key, or a contract, controlled by its code |
| bps | Basis point: 0.01% |
| Call | A read-only execution that changes nothing and costs no gas to the user |
| Calldata | The read-only input data of an external call |
| Checks-effects-interactions | Ordering rule: validate, update your own state, then call other addresses |
| Custom error | A named error with arguments, declared with `error` |
| EIP | Ethereum Improvement Proposal |
| ETH | Ether, the native currency of Ethereum |
| Event | A log entry emitted by a contract and stored with the transaction |
| EVM | Ethereum Virtual Machine, which executes contract code |
| Fork | A version of the EVM rules, such as Cancun |
| Gas | The unit measuring the work a transaction requires |
| Immutable | A variable set once in the constructor and read-only afterwards |
| Modifier | Reusable code wrapped around a function |
| Panic | An error raised by the language itself, such as an arithmetic overflow |
| Reentrancy | Calling back into a contract while one of its functions is still running |
| Remix VM | A simulated blockchain running in the browser |
| Revert | Cancelling a transaction and undoing all its changes |
| Slot | A 32-byte unit of contract storage |
| Transaction | A signed request that can change state and costs gas |
| Transient storage | Storage that is erased at the end of each transaction |
| Wei | The smallest unit of ETH: 1 ether = 10^18 wei |
