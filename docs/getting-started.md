# Getting started

## Open Remix

Go to <https://remix.ethereum.org>. Remix keeps your files in the browser, per web address: files created at one address do not appear at another, and clearing the browser data removes them.

## Load the contracts

Pick one of the two ways.

**Clone the repository (recommended)**

1. In the **File explorer**, open the workspace menu at the top (the name of the current workspace).
2. Choose **Clone**.
3. Paste the URL of this repository and confirm.

Remix creates a workspace containing the `contracts` and `docs` folders.

**Upload the folder**

1. Download this repository as a ZIP file and unpack it.
2. In the **File explorer**, create a blank workspace.
3. Use **Upload folder** and select the `contracts` folder.

Keep the folder structure as it is: some files import others with relative paths.

## Set up the compiler

1. Open the **Solidity compiler** tab.
2. Select compiler version **0.8.30**. A later 0.8.x version also works.
3. Leave the EVM version on its default.
4. Optional: tick **Auto compile** so files compile as you open them.

To compile a file, open it and press `Ctrl+S` (`Cmd+S` on macOS) or click **Compile**.

The first time you compile a file that uses `console.log`, Remix downloads `hardhat/console.sol` and stores it in a `.deps` folder. This is expected.

## Set up the environment

1. Open the **Deploy & run transactions** tab.
2. Set **Environment** to **Remix VM**. Any fork from Cancun onwards works; the default one is fine.
3. Note the **Account** list: several test accounts, each with 100 ETH.

## Deploy your first contract

1. Open `contracts/basics/HelloLogs.sol` and compile it.
2. In **Deploy & run transactions**, check that the **Contract** list shows `HelloLogs`.
3. Click **Deploy**.
4. The contract appears under **Deployed Contracts**. Expand it to see one button per function.
5. Look at the terminal at the bottom of the screen: it shows a line printed by the constructor.

Continue with [Reading the terminal](reading-the-terminal.md), then the [Basics](basics.md) guide.

## When a file holds several contracts

Some files declare more than one contract. Before deploying, choose the one you want in the **Contract** list of the Deploy panel. Interfaces and abstract contracts are listed too, and cannot be deployed.

## Deploying a contract that needs another contract's address

Some contracts take an address in their constructor (for example `Attacker` needs the vault's address). Copy the address with the copy icon next to the deployed contract's name, paste it in the field next to **Deploy**, then deploy.
