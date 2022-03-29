Receipt token used accross protocols that bribe integrate, ping the gauge before and after a token transfer


## Functions
### constructor
```solidity
  function constructor(
    string name_,
    string symbol_,
    contract IERC20 underlying_,
    contract IGauge gauge_
  ) public
```
@notice


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`name_` | string | Receipt token name
|`symbol_` | string | Receipt token symbol
|`underlying_` | contract IERC20 | 1:1 governance token this receipt token represent
|`gauge_` | contract IGauge | Gauge contract to keep accounting with

### mint
```solidity
  function mint(
    address user,
    uint256 amount
  ) external
```


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`user` | address | Account to mint token to
|`amount` | uint256 | Amount of token to mint

### burn
```solidity
  function burn(
    address user,
    uint256 amount
  ) external
```


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`user` | address | Account to burn token to
|`amount` | uint256 | Amount of token to burn

### _beforeTokenTransfer
```solidity
  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal
```
AccumulateBidRewards before a token transfer, (leave a snapshot before updating user amount)


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`from` | address | Sender
|`to` | address | Receiptor
|`amount` | uint256 | Amount being transfered

### _afterTokenTransfer
```solidity
  function _afterTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal
```
accumulate bribe and staking rewards, creates a checkpoint on the gauge before updating gauges balance


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`from` | address | Sender
|`to` | address | Receiptor
|`amount` | uint256 | Amount being transfered

### accumulateBidRewards
```solidity
  function accumulateBidRewards(
    address from,
    address to
  ) internal
```
internal utility function to accumulate bid rewards


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`from` | address | Sender
|`to` | address | Receiptor

