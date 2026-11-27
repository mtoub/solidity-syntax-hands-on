# Troubleshooting

**"Source file requires different compiler version"**

Select compiler 0.8.30 or a later 0.8.x version in the **Solidity compiler** tab.

**"Source "hardhat/console.sol" not found"**

In Remix, compile again: the file is downloaded on first use and needs an internet connection. In a local editor outside Remix, this message is expected unless Hardhat is installed in the project.

**No console lines in the terminal**

`console.log` only prints on **Remix VM**. Check the **Environment** in the Deploy panel. With an injected wallet or a test network, nothing is printed.

**No console lines for a transaction that reverted**

Depending on the Remix version, the lines of a reverted transaction may not be shown. In the reentrancy lab, deploy `Attacker` with `true` so the transaction completes and everything is visible.

**Errors about transient storage or the EVM version**

Transient storage needs the Cancun fork or later. In the compiler's advanced settings, set the EVM version to the default or to Cancun or later. In the Deploy panel, pick a Remix VM fork of Cancun or later.

**"This contract may be abstract"**

An interface or an abstract contract is selected in the **Contract** list. Select the concrete contract.

**"Gas estimation failed"**

The transaction is going to revert. Several exercises do this on purpose: choose **Send Transaction** to see the reason. If it was not expected, check the selected account, the **Value** field and the arguments.

**A payable call fails with "Send exactly 1 ether"**

**Value** returns to 0 after each transaction. Set it again, and check the unit is Ether.

**A relative import is not found**

Keep the folder structure of the repository. Files in `reentrancy`, `capstone` and `solutions` import each other with relative paths.

**The wrong contract gets deployed**

When a file declares several contracts, choose the right one in the **Contract** list before clicking **Deploy**.

**Deployed contracts have disappeared**

Reloading the page or changing the environment resets Remix VM. Deploy again.

**Extra warnings with a newer compiler**

Later 0.8.x versions can add deprecation warnings, for example on `transfer`. Warnings do not prevent deployment.
