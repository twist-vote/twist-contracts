pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IGauge {
    /**
     * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
     */
    event GaugeAdded(address govToken, uint256 weight);

    event GaugeUpdated(uint256 lastRewardBlock, uint256 accTokenPerShare);

    event RewardsAccumulated(address user, address govToken);

    function setRewardsPerBlocks(uint256 rewardsPerBlock_) external;

    function add(
        IERC20 _govToken,
        address _receiptToken,
        uint256 _weight,
        address _additionalTokenRewards
    ) external;

    function set(IERC20 govToken, uint256 _weight) external;

    function rewardBalanceOf(IERC20 _token, address _user)
        external
        view
        returns (uint256 pending, uint256 additionalPending);

    function accrueAdditionalRewards(address govToken, uint256 amount) external;

    function accumulateRewards(address govToken, address _user) external;

    // function accumulateBidRewards(address govToken, address account) external;

    function claimRewards(address govToken, address to) external;
}
