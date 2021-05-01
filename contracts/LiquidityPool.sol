// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "./UnderlyingToken.sol";
import "./LpToken.sol";
import "./GovernanceToken.sol";

contract LiquidityPool is LpToken {
    mapping(address => uint256) checkpoints;
    UnderlyingToken public underlyingToken;
    GovernanceToken public governanceToken;
    uint256 public constant REWARD_PER_BLOCK = 1;

    constructor(address _underlyingToken, address _governanceToken) {
        underlyingToken = UnderlyingToken(_underlyingToken);
        governanceToken = GovernanceToken(_governanceToken);
    }

    function deposit(uint256 amount) external {
        if (checkpoints[msg.sender] == 0) {
            checkpoints[msg.sender] = block.number;
        }
        _distributeRewards(msg.sender);
        underlyingToken.transferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "not enough LP tokens");
        _distributeRewards(msg.sender);
        underlyingToken.transfer(msg.sender, amount);
        _burn(msg.sender, amount);
    }

    function _distributeRewards(address beneficiary) internal {
        uint256 checkpoint = checkpoints[beneficiary];
        if (block.number - checkpoint > 0) {
            uint256 distributionAmount =
                balanceOf(beneficiary) *
                    (block.number - checkpoint) *
                    REWARD_PER_BLOCK;
            governanceToken.mint(beneficiary, distributionAmount);
            checkpoints[beneficiary] = block.number;
        }
    }
}
