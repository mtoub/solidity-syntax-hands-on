// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// What every vault in this folder offers. The Attacker and BatchUser contracts
// only know this interface, so they work against any of the vaults.
interface IVault {
    function deposit() external payable;
    function withdraw() external;
}
