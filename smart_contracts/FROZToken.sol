// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FROZToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 1e18; // 1B FROZ

    // 10% burn on transfers flagged as marketplace fees
    mapping(address => bool) public isMarketplace;

    event MarketplaceSet(address account, bool status);

    constructor() ERC20("FROZ Token", "FROZ") {
        _mint(msg.sender, MAX_SUPPLY);
    }

    function setMarketplace(address account, bool status) external onlyOwner {
        isMarketplace[account] = status;
        emit MarketplaceSet(account, status);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 burnAmount = 0;
        uint256 sendAmount = amount;

        if(isMarketplace[sender] || isMarketplace[recipient]) {
            burnAmount = (amount * 10) / 100; // 10% burn
            sendAmount = amount - burnAmount;
            _burn(sender, burnAmount);
        }

        super._transfer(sender, recipient, sendAmount);
    }
}
