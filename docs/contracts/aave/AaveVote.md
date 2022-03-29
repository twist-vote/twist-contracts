


## Functions
### constructor
```solidity
  function constructor(
  ) public
```




### vote
```solidity
  function vote(
    uint256 proposalID
  ) external
```
vote on a proposalID, dispatch bid rewards accross both governance tokens


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`proposalID` | uint256 | proposal to vote on

### createProposal
```solidity
  function createProposal(
    contract IExecutorWithTimelock executor,
    address[] targets,
    uint256[] values,
    string[] signatures,
    bytes[] calldatas,
    bool[] withDelegatecalls,
    bytes32 ipfsHash
  ) external returns (uint256 proposalId)
```
use the pool voting power to create a new proposal
the price to pay is set by vault stakers


#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`executor` | contract IExecutorWithTimelock | aave executor to use
|`targets` | address[] | list of address to call
|`values` | uint256[] | uint256[],
|`signatures` | string[] | string[],
|`calldatas` | bytes[] | bytes[],
|`withDelegatecalls` | bool[] | bool[],
|`ipfsHash` | bytes32 | bytes32

## Events
### ProposalCreated
```solidity
  event ProposalCreated(
  )
```



