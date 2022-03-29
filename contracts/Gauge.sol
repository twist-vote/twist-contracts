// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./GaugeSnapshot.sol";
import "./interfaces/IGauge.sol";

/// @title Gauge
/// @notice This gauge will be used in conjunction with a receipt token used in the different bribe pools
/// @dev
contract Gauge is GaugeSnapshot, IGauge {
    /// @notice Info for each user.
    /// `amount` token amount the user has provided, (need to be stored)
    /// `rewardDebt` The amount of rewardToken entitled to the user.
    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
        mapping(address => uint256) additionalRewardDebt;
    }
    /// @notice Info of each LM pool.
    /// additionalRewardsToken sometimes, we need to distribute bribe and one additional gov token for stakers
    /// accTokenPerShare amount of bribe accumulated per share since pool inception.
    /// accAdditionalTokenPerShare amount of staking rewards accumulated per share since pool inception.
    /// lastRewardBlock last time pool info were updated (and reward distributed)
    /// weight current pool weight, share of reward rate defined for this gauge
    /// supply total supply for the underlying asset, need to be stored to update pool correctly
    struct GaugeInfo {
        address additionalRewardsToken;
        uint256 accTokenPerShare;
        uint256 accAdditionalTokenPerShare;
        uint64 lastRewardBlock;
        uint256 weight;
        uint256 supply;
    }

    using SafeERC20 for IERC20;

    /// @notice Address of rewardToken contract.
    IERC20 public immutable rewardToken;

    uint256 internal totalWeight;

    /// @notice reward this contract dispatch accross gauge at each block
    uint256 public rewardsPerBlock;

    /// @notice Info of each pool.
    mapping(address => GaugeInfo) public gaugeInfo;

    /// @notice Info of each user that stakes LP tokens.
    mapping(address => mapping(address => UserInfo)) public userInfo;

    /// @notice
    uint256 private constant ACC_INST_PRECISION = 1e12;

    /// @notice
    /// @dev
    /// @param rewardToken_ ()
    constructor(IERC20 rewardToken_, IERC20 bidToken_) GaugeSnapshot(bidToken_) {
        rewardToken = rewardToken_;
    }

    function setRewardsPerBlocks(uint256 rewardsPerBlock_) external override onlyOwner {
        rewardsPerBlock = rewardsPerBlock_;
    }

    /// @notice Add a new gauge token to the contract. Can only be called by the owner. (do not call it twice for the same token!)
    /// @param _govToken govToken for which we generate rewards
    /// @param _receiptToken recdeipt token used for this gauge
    /// @param _weight underlying pool weight
    /// @param _additionalTokenRewards additional token to distribute as rewards
    function add(
        IERC20 _govToken,
        address _receiptToken,
        uint256 _weight,
        address _additionalTokenRewards
    ) external override onlyOwner {
        massUpdatePools();
        // claimableRewards += _maxReward;
        // require(rewardToken.balanceOf(address(this)) > claimableRewards, "INSUFICIENT_FUNDS");

        gaugeInfo[address(_govToken)] = GaugeInfo({
            additionalRewardsToken: _additionalTokenRewards,
            accAdditionalTokenPerShare: 0,
            accTokenPerShare: 0,
            lastRewardBlock: uint64(block.number),
            weight: _weight,
            supply: 0
        });

        tokens.push(address(_govToken));

        receiptToToken[_receiptToken] = address(_govToken);
        tokenToReceipt[address(_govToken)] = _receiptToken;

        totalWeight += _weight;

        emit GaugeAdded(address(_govToken), _weight);
    }

    /// @notice change weight for a specific pool
    /// @param govToken governance token we want to assign a new weight
    /// @param _weight new weight for the given gauge
    function set(IERC20 govToken, uint256 _weight) external override onlyOwner {
        GaugeInfo storage gauge = gaugeInfo[address(govToken)];
        // totalweight is about to be changed, mark a checkpoint in every pool
        massUpdatePools();
        totalWeight = totalWeight + _weight - gauge.weight;
        gauge.weight = _weight;
    }

    /// @notice Update reward variables for all pools. Be careful of gas spending!
    /// used once in a while to reflect new votes on pools
    function massUpdatePools() public {
        for (uint256 i = 0; i < tokens.length; ++i) {
            updateGauge(IERC20(tokens[i]), 0);
        }
    }

    /// @notice View function to see pending rewardToken on frontend.
    /// @param _token governance token address the gauge is attached to
    /// @param _user Address of user.
    /// @return pending rewardToken reward for a given user.
    function rewardBalanceOf(IERC20 _token, address _user)
        external
        view
        override
        returns (uint256 pending, uint256 additionalPending)
    {
        GaugeInfo memory gauge = gaugeInfo[address(_token)];
        UserInfo storage user = userInfo[address(_token)][_user];
        // uint256 mintedReward = gauge.accTokenPerShare * gauge.supply;
        uint256 gaugeRewardsPerBlock = ((gauge.weight * ACC_INST_PRECISION) / totalWeight) *
            rewardsPerBlock;
        if (block.number > gauge.lastRewardBlock) {
            uint256 blocks = block.number - gauge.lastRewardBlock;
            uint256 bribeReward = blocks * gaugeRewardsPerBlock;
            uint256 accTokenPerShare = gauge.accTokenPerShare + (bribeReward / gauge.supply);
            gauge.accTokenPerShare = accTokenPerShare;
        }
        pending = ((user.amount * gauge.accTokenPerShare) / ACC_INST_PRECISION) - user.rewardDebt;
        additionalPending =
            ((user.amount * gauge.accAdditionalTokenPerShare) / ACC_INST_PRECISION) -
            user.additionalRewardDebt[address(_token)];
    }

    /// @notice Update reward variables of the given pool.
    /// @param token The governance token address of the gauge. See `gaugeInfo`.
    /// @param additionalTokenAmount possible increase in staking rewards to be reflected in the pool
    /// @return gauge Returns the pool that was updated.
    function updateGauge(IERC20 token, uint256 additionalTokenAmount)
        public
        returns (GaugeInfo memory gauge)
    {
        gauge = gaugeInfo[address(token)];

        if (additionalTokenAmount != 0 && gauge.additionalRewardsToken != address(0)) {
            gauge.accAdditionalTokenPerShare +=
                (additionalTokenAmount * ACC_INST_PRECISION) /
                gauge.supply;
        }

        // uint256 mintedReward = gauge.accTokenPerShare * gauge.supply;
        uint256 gaugeRewardsPerBlock = ((gauge.weight * ACC_INST_PRECISION) / totalWeight) *
            rewardsPerBlock;
        if (block.number > gauge.lastRewardBlock) {
            if (gauge.supply > 0) {
                uint256 blocks = block.number - gauge.lastRewardBlock;
                uint256 bribeReward = blocks * gaugeRewardsPerBlock;
                uint256 rewardFactor = bribeReward / gauge.supply;
                uint256 accTokenPerShare = gauge.accTokenPerShare + rewardFactor;
                gauge.accTokenPerShare = accTokenPerShare;
            }
            gauge.lastRewardBlock = uint64(block.number);
            gaugeInfo[address(token)] = gauge;
            emit GaugeUpdated(gauge.lastRewardBlock, gauge.accTokenPerShare);
        }
    }

    /// @notice accdrue staking rewards for a specific governance token, external and unprotected
    /// @param govToken governance token
    /// @param amount staking rewards amount to increase
    function accrueAdditionalRewards(address govToken, uint256 amount) external override {
        // check if rewards have indeed increased
        GaugeInfo memory gauge = gaugeInfo[govToken];
        IERC20(gauge.additionalRewardsToken).safeTransferFrom(msg.sender, address(this), amount);
        updateGauge(IERC20(govToken), amount);
    }

    /// @notice function to be called by receipt token on each mint, burn, transfer action
    /// @param govToken governance token
    /// @param _user user address for which we accumulate rewards
    function accumulateRewards(address govToken, address _user) external override {
        require(govToken == receiptToToken[msg.sender], "WRONG_SENDER");
        updateGauge(IERC20(govToken), 0);
        UserInfo storage user = userInfo[govToken][_user];
        GaugeInfo storage gauge = gaugeInfo[govToken];

        // amount differential negative if deposit, positive if withdraw
        int256 differential = int256(user.amount) -
            int256(IERC20(tokenToReceipt[govToken]).balanceOf(_user));

        // Effects
        user.rewardDebt = uint256(
            int256(user.rewardDebt) -
                ((differential * int256(gauge.accTokenPerShare)) / int256(ACC_INST_PRECISION))
        );

        if (gauge.additionalRewardsToken != address(0)) {
            user.additionalRewardDebt[govToken] = uint256(
                int256(user.additionalRewardDebt[govToken]) -
                    ((differential * int256(gauge.accAdditionalTokenPerShare)) /
                        int256(ACC_INST_PRECISION))
            );
        }
        user.amount = IERC20(tokenToReceipt[govToken]).balanceOf(_user);
        gauge.supply = IERC20(tokenToReceipt[govToken]).totalSupply();

        emit RewardsAccumulated(_user, govToken);
    }

    /// @notice claim rewards on a specific gauge
    /// @param govToken governance token
    /// @param to account that will receive the rewards
    function claimRewards(address govToken, address to) external override {
        _claimRewards(govToken, to);
    }

    /// @notice claimRewards is called by the user holding pending rewards
    /// @param govToken the receiptToken for which to claim rewards
    /// @param to the account to send the rewards
    function _claimRewards(address govToken, address to) internal {
        super._claimRewards(to);
        updateGauge(IERC20(govToken), 0);
        UserInfo storage user = userInfo[govToken][msg.sender];
        GaugeInfo storage pool = gaugeInfo[govToken];

        uint256 accumulatedBribe = (user.amount * pool.accTokenPerShare) / ACC_INST_PRECISION;
        uint256 accumulatedAdditionalRewards = (user.amount * pool.accAdditionalTokenPerShare) /
            ACC_INST_PRECISION;
        uint256 pendingReward = accumulatedBribe - user.rewardDebt;
        uint256 pendingAdditionalRewards = accumulatedAdditionalRewards -
            user.additionalRewardDebt[govToken];

        // Effects
        user.rewardDebt = accumulatedBribe;
        user.additionalRewardDebt[govToken] = accumulatedAdditionalRewards;

        if (pendingReward > 0) {
            // Interactions
            // claimableRewards -= pendingReward;
            rewardToken.transfer(to, pendingReward);
            IERC20(pool.additionalRewardsToken).transfer(to, pendingAdditionalRewards);
        }
    }
}
