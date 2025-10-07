// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract StudentData {
    // Structure to store student information
    struct Student {
        uint id;
        string name;
        uint age;
        string course;
    }

    // Dynamic array to store multiple students
    Student[] public students;

    // Owner of the contract
    address public owner;

    // Events for logs
    event StudentAdded(uint id, string name);
    event Received(address sender, uint amount);
    event FallbackCalled(address sender, uint amount, bytes data);

    constructor() {
        owner = msg.sender; // The account deploying the contract becomes the owner
    }

    // Function to add a student to the array
    function addStudent(uint _id, string memory _name, uint _age, string memory _course) public {
        Student memory newStudent = Student({
            id: _id,
            name: _name,
            age: _age,
            course: _course
        });
        students.push(newStudent);
        emit StudentAdded(_id, _name);
    }

    // Function to get total number of students
    function getTotalStudents() public view returns (uint) {
        return students.length;
    }

    // Function to get student details by index
    function getStudent(uint index) public view returns (uint, string memory, uint, string memory) {
        require(index < students.length, "Invalid index");
        Student memory s = students[index];
        return (s.id, s.name, s.age, s.course);
    }

    // Function to receive ETH (called when someone sends ETH directly)
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // Fallback function (called when function name not found)
    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data);
    }
}