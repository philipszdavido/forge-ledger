// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FROZToken.sol";

contract FROZStaking {
    FROZToken public token;
    uint256 public APY = 100; // Example: 100% APY
    uint256 public constant SECONDS_IN_YEAR = 31536000;

    struct Stake {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => Stake) public stakes;

    constructor(FROZToken _token) {
        token = _token;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        token.transferFrom(msg.sender, address(this), amount);

        if(stakes[msg.sender].amount > 0){
            uint256 reward = calculateReward(msg.sender);
            stakes[msg.sender].amount += reward;
        }

        stakes[msg.sender].amount += amount;
        stakes[msg.sender].startTime = block.timestamp;
    }

    function withdraw() external {
        Stake memory userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No stake found");

        uint256 reward = calculateReward(msg.sender);
        uint256 total = userStake.amount + reward;

        stakes[msg.sender].amount = 0;
        stakes[msg.sender].startTime = 0;

        token.transfer(msg.sender, total);
    }

    function calculateReward(address user) public view returns (uint256) {
        Stake memory s = stakes[user];
        if(s.amount == 0) return 0;

        uint256 duration = block.timestamp - s.startTime;
        uint256 reward = (s.amount * APY * duration) / (100 * SECONDS_IN_YEAR);
        return reward;
    }
}
