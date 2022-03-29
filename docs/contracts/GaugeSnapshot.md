Snapshot gauge, used to distribute bid rewards to vault staker.
Borrow snapshot logic from ERC20Snapshot to accurately distribute rewards based on a previous snapshot from stakers


## Functions
### constructor
```solidity
  function constructor(
  ) internal
```




### _snapshot
```solidity
  function _snapshot(
    address token
  ) internal returns (uint256)
```
create a new snapshot, a new snapshot will be created at this point in time


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`token` | address | for which to create the snapshot

### _getCurrentSnapshotId
```solidity
  function _getCurrentSnapshotId(
  ) internal returns (uint256)
```

Get the current snapshotId


### balanceOfAt
```solidity
  function balanceOfAt(
  ) public returns (uint256)
```

Retrieves the balance of `account` at the time `snapshotId` was created.


### totalSupplyAt
```solidity
  function totalSupplyAt(
  ) public returns (uint256)
```

Retrieves the total supply at the time `snapshotId` was created.


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

### _claimRewards
```solidity
  function _claimRewards(
    address to
  ) internal
```
claim bid rewards for all the governance tokens


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`to` | address | Address to claim rewards for

### pendingRewards
```solidity
  function pendingRewards(
  ) public returns (uint256 rewards)
```
get the current pending rewards for msg.sender



