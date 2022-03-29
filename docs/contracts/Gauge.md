This gauge will be used in conjunction with a receipt token used in the different bribe pools
@dev


## Functions
### constructor
```solidity
  function constructor(
    contract IERC20 rewardToken_
  ) public
```
@notice
@dev


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`rewardToken_` | contract IERC20 | ()

### setRewardsPerBlocks
```solidity
  function setRewardsPerBlocks(
  ) external
```




### add
```solidity
  function add(
    contract IERC20 _govToken,
    address _receiptToken,
    uint256 _weight,
    address _additionalTokenRewards
  ) external
```
Add a new gauge token to the contract. Can only be called by the owner. (do not call it twice for the same token!)


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`_govToken` | contract IERC20 | govToken for which we generate rewards
|`_receiptToken` | address | recdeipt token used for this gauge
|`_weight` | uint256 | underlying pool weight
|`_additionalTokenRewards` | address | additional token to distribute as rewards

### set
```solidity
  function set(
    contract IERC20 govToken,
    uint256 _weight
  ) external
```
change weight for a specific pool


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`govToken` | contract IERC20 | governance token we want to assign a new weight
|`_weight` | uint256 | new weight for the given gauge

### massUpdatePools
```solidity
  function massUpdatePools(
  ) public
```
Update reward variables for all pools. Be careful of gas spending!
used once in a while to reflect new votes on pools



### rewardBalanceOf
```solidity
  function rewardBalanceOf(
    contract IERC20 _token,
    address _user
  ) external returns (uint256 pending, uint256 additionalPending)
```
View function to see pending rewardToken on frontend.


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`_token` | contract IERC20 | governance token address the gauge is attached to
|`_user` | address | Address of user.

#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`pending`| contract IERC20 | rewardToken reward for a given user.
### updateGauge
```solidity
  function updateGauge(
    contract IERC20 token,
    uint256 additionalTokenAmount
  ) public returns (struct Gauge.GaugeInfo gauge)
```
Update reward variables of the given pool.


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`token` | contract IERC20 | The governance token address of the gauge. See `gaugeInfo`.
|`additionalTokenAmount` | uint256 | possible increase in staking rewards to be reflected in the pool

#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`gauge`| contract IERC20 | Returns the pool that was updated.
### accrueAdditionalRewards
```solidity
  function accrueAdditionalRewards(
    address govToken,
    uint256 amount
  ) external
```
accdrue staking rewards for a specific governance token, external and unprotected


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`govToken` | address | governance token
|`amount` | uint256 | staking rewards amount to increase

### accumulateRewards
```solidity
  function accumulateRewards(
    address govToken,
    address _user
  ) external
```
function to be called by receipt token on each mint, burn, transfer action


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`govToken` | address | governance token
|`_user` | address | user address for which we accumulate rewards

### claimRewards
```solidity
  function claimRewards(
    address govToken,
    address to
  ) external
```
claim rewards on a specific gauge


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`govToken` | address | governance token
|`to` | address | account that will receive the rewards

### _claimRewards
```solidity
  function _claimRewards(
    address govToken,
    address to
  ) internal
```
claimRewards is called by the user holding pending rewards


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`govToken` | address | the receiptToken for which to claim rewards
|`to` | address | the account to send the rewards

