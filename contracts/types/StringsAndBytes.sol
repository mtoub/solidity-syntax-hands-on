// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: text.
//   string    dynamic UTF-8 text, flexible but costly to store
//   bytes32   exactly 32 bytes, cheap, good for short fixed labels
//
// Try: read label and shortLabel. Call setLabel("hello"), then
// join("Hello, ", "world"), then sameText("abc", "abc").
// Look for: label as readable text, shortLabel as hex padded with zeros.
contract StringsAndBytes {
    string public label = "Solidity syntax";
    bytes32 public shortLabel = "Solidity syntax";

    event LabelChanged(string oldLabel, string newLabel);

    function setLabel(string calldata newLabel) external {
        console.log("setLabel: from '%s' to '%s'", label, newLabel);
        emit LabelChanged(label, newLabel);
        label = newLabel;
    }

    // A string has no length member: convert to bytes to count the bytes
    function labelLength() external view returns (uint256) {
        return bytes(label).length;
    }

    function join(string calldata a, string calldata b) external pure returns (string memory) {
        return string.concat(a, b);
    }

    // Strings cannot be compared with ==. Compare their hashes instead.
    function sameText(string calldata a, string calldata b) external pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

// Challenge: add setShortLabel(bytes32) and call it from Remix.
// What do you have to type in the input field?
