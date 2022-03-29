This contract is used by vault staker to set up a price on the creation of proposals


## Functions
### constructor
```solidity
  function constructor(
    contract IERC20 receiptToken_,
    address[3] executors_
  ) internal
```
@notice


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`receiptToken_` | contract IERC20 | receipt tokens to compute the "voting power" for each pricer
|`executors_` | address[3] | protocols sometimes have different executors (time till end of vote), logically the longer the executor the more expensive it is

### setPrice
```solidity
  function setPrice(
    uint256[3] prices
  ) external
```
let a user set his price to let Bribe pass new proposal with his voting power


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`prices` | uint256[3] | (uint256) consider at most 3 kind of executor / protocol, from shorter to longer

### getPrices
```solidity
  function getPrices(
  ) public returns (uint256[3])
```
getPrice for each executors



