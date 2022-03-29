abstract contract to be extended by vote contract for each protocol, allow admin to block certain proposal ID
making them impossible to bid or vote on.


## Functions
### blockProposal
```solidity
  function blockProposal(
    uint256 proposalID
  ) external
```
Block proposals, reserved for admin, should refund all active bidders


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`proposalID` | uint256 | proposal ID

### _afterProposalBlocked
```solidity
  function _afterProposalBlocked(
    uint256 proposalID
  ) internal
```
Virtual function to be extended for refund


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`proposalID` | uint256 | Proposal ID

### unBlockProposal
```solidity
  function unBlockProposal(
    uint256 proposalID
  ) external
```
Un-Block a proposal, reserved for admin


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`proposalID` | uint256 | proposal to unlock

### _afterProposalUnBlocked
```solidity
  function _afterProposalUnBlocked(
  ) internal
```




## Events
### BlockedProposal
```solidity
  event BlockedProposal(
  )
```



### UnBlockedProposal
```solidity
  event UnBlockedProposal(
  )
```



