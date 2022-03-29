


## Functions
### accumulateBidRewards
```solidity
  function accumulateBidRewards(
    address govToken,
    address account
  ) external
```
called by the receipt token, create a checkpoint for each deposit, transfer, mint of the underlying receiptToken


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`govToken` | address | governance token
|`account` | address | account address for which we accumulate rewards

### accrueBidReward
```solidity
  function accrueBidReward(
    address token,
    uint256 amount
  ) external
```
accrue rewards for the bid token, unprotected external function, a hacker wishing to distribute more rewards is free to do so


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`token` | address | governance token for which to accrue bid rewards
|`amount` | uint256 | rewards amount to accrue

## Events
### Snapshot
```solidity
  event Snapshot(
  )
```

Emitted by {_snapshot} when a snapshot identified by `id` is created.

### RewardsClaimed
```solidity
  event RewardsClaimed(
  )
```



### BidRewardsAccrued
```solidity
  event BidRewardsAccrued(
  )
```



