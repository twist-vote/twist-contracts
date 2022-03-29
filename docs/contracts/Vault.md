Abstract contract for underlying protocol vault implementation,
support up to 2 different governance tokens per vault


## Functions
### constructor
```solidity
  function constructor(
    contract IERC20[2] govTokens_,
    contract IGauge gauge_
  ) internal
```
In order to mutualise code accross vault, each vault can initialize up to 2 governance tokens


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`govTokens_` | contract IERC20[2] | The governance tokens this vault will manage
|`gauge_` | contract IGauge | The gauge this vault will communicate with

### _afterDeposit
```solidity
  function _afterDeposit(
    uint256 amount,
    address to,
    uint8 tokenIndex
  ) internal
```
Virtual function to take action after a deposit event


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`amount` | uint256 | Amount to deposit
|`to` | address | Account to credit
|`tokenIndex` | uint8 | Which governance token index we deposit

### deposit
```solidity
  function deposit(
    uint256 amount,
    address to,
    uint8 tokenIndex
  ) external
```
deposit one of the governance token


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`amount` | uint256 | amount to deposit
|`to` | address | account for which we deposit
|`tokenIndex` | uint8 | which of the 2 governance tokens we are depositing

### _afterWithdraw
```solidity
  function _afterWithdraw(
    uint256 amount,
    address to,
    uint8 tokenIndex
  ) internal
```
Virtual function to take action after a deposit event


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`amount` | uint256 | Amount to deposit
|`to` | address | Account to credit
|`tokenIndex` | uint8 | Which governance token index we deposit

### withdraw
```solidity
  function withdraw(
    uint256 amount,
    address to,
    uint8 tokenIndex
  ) external
```
withdraw one of the governance token


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`amount` | uint256 | amount to deposit
|`to` | address | account for which we deposit
|`tokenIndex` | uint8 | which of the 2 governance tokens we are withdrawing

