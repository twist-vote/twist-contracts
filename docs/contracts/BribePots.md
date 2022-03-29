BribePots abstract contract, to be extended by pools who support bilateral proposals.


## Functions
### constructor
```solidity
  function constructor(
  ) internal
```




### bid
```solidity
  function bid(
    uint256 proposalID,
    uint256 amount,
    bool support
  ) external
```
Bid on bilateral proposals, choose a side and increase the amount bidded, the side with the highest amount wins the vote.


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`proposalID` | uint256 | proposal id to bid on
|`amount` | uint256 | to bid
|`support` | bool | on which side the bid will be active

