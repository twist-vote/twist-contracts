pragma solidity ^0.8.4;

interface IGaugeSnapshot {
    /**
     * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
     */
    event Snapshot(uint256 id);

    event RewardsClaimed(uint256 amount, address to);

    event BidRewardsAccrued(address token, uint256 amount);

    /// @notice called by the receipt token, create a checkpoint for each deposit, transfer, mint of the underlying receiptToken
    /// @param govToken governance token
    /// @param account account address for which we accumulate rewards
    function accumulateBidRewards(address govToken, address account) external;

    /// @notice accrue rewards for the bid token, unprotected external function, a hacker wishing to distribute more rewards is free to do so
    /// @param token governance token for which to accrue bid rewards
    /// @param amount rewards amount to accrue
    function accrueBidReward(address token, uint256 amount) external;
}
