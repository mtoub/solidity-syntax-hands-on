// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

// Concept: a struct groups related fields under one name, like a record.
//
// Try: addStudent("Alice", 22), then students(0) and studentCount.
// Switch account and add a second student.
// Look for: the wallet field holding the address of whoever added the student.
contract Structs {
    struct Student {
        string name;
        uint16 age;
        address wallet;
    }

    Student[] public students;

    event StudentAdded(uint256 indexed index, string name, uint16 age, address wallet);

    function addStudent(string calldata name, uint16 age) external {
        // Build the struct in memory, then copy it into storage.
        // Named fields make the order irrelevant and the code easier to read.
        Student memory s = Student({name: name, age: age, wallet: msg.sender});
        students.push(s);

        console.log("addStudent: %s, age %s, wallet %s", name, age, msg.sender);
        emit StudentAdded(students.length - 1, name, age, msg.sender);
    }

    function studentCount() external view returns (uint256) {
        return students.length;
    }

    // Returning a whole struct
    function getStudent(uint256 index) external view returns (Student memory) {
        return students[index];
    }
}

// Challenge: add birthday(uint256 index) that increases a student's age by one.
// DataLocation.sol explains why the keyword you pick for the local variable matters.
