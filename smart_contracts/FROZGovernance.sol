// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FROZToken.sol";

contract FROZGovernance {
    FROZToken public token;

    struct Proposal {
        string description;
        uint256 voteYes;
        uint256 voteNo;
        uint256 startTime;
        uint256 endTime;
        bool executed;
    }

    Proposal[] public proposals;

    mapping(address => mapping(uint256 => bool)) public hasVoted;

    constructor(FROZToken _token) {
        token = _token;
    }

    function createProposal(string calldata description, uint256 duration) external {
        proposals.push(Proposal({
            description: description,
            voteYes: 0,
            voteNo: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + duration,
            executed: false
        }));
    }

    function vote(uint256 proposalId, bool support) external {
        Proposal storage p = proposals[proposalId];
        require(block.timestamp >= p.startTime && block.timestamp <= p.endTime, "Voting closed");
        require(!hasVoted[msg.sender][proposalId], "Already voted");

        uint256 votingPower = token.balanceOf(msg.sender);
        require(votingPower > 0, "No FROZ to vote");

        if(support) p.voteYes += votingPower;
        else p.voteNo += votingPower;

        hasVoted[msg.sender][proposalId] = true;
    }

    function executeProposal(uint256 proposalId) external {
        Proposal storage p = proposals[proposalId];
        require(block.timestamp > p.endTime, "Voting not finished");
        require(!p.executed, "Already executed");

        // For now: just mark executed
        p.executed = true;
    }
}
