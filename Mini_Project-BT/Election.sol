// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Election {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    uint public candidatesCount;
    address public owner;
    bool public votingActive;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // Add candidate before voting starts
    function addCandidate(string memory _name) public onlyOwner {
        require(!votingActive, "Cannot add candidates while voting is active");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // Start voting
    function startVoting() public onlyOwner {
        require(!votingActive, "Voting already active");
        votingActive = true;
    }

    // End voting
    function endVoting() public onlyOwner {
        require(votingActive, "Voting not active");
        votingActive = false;
    }

    // Cast vote
    function vote(uint _candidateId) public {
        require(votingActive, "Voting not active");
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
    }

    // Get candidate info
    function getCandidate(uint _id) public view returns (uint, string memory, uint) {
        Candidate memory c = candidates[_id];
        return (c.id, c.name, c.voteCount);
    }

    // Declare winner
    function getWinner() public view returns (string memory winnerName, uint winnerVotes) {
        uint maxVotes = 0;
        uint winnerId = 0;
        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }
        if (winnerId == 0) {
            return ("No votes yet", 0);
        }
        return (candidates[winnerId].name, candidates[winnerId].voteCount);
    }
}