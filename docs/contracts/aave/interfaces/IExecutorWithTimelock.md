


## Functions
### getAdmin
```solidity
  function getAdmin(
  ) external returns (address)
```

Getter of the current admin address (should be governance)


#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`The`|  | address of the current admin

### getPendingAdmin
```solidity
  function getPendingAdmin(
  ) external returns (address)
```

Getter of the current pending admin address


#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`The`|  | address of the pending admin

### getDelay
```solidity
  function getDelay(
  ) external returns (uint256)
```

Getter of the delay between queuing and execution


#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`The`|  | delay in seconds

### isActionQueued
```solidity
  function isActionQueued(
    bytes32 actionHash
  ) external returns (bool)
```

Returns whether an action (via actionHash) is queued

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`actionHash` | bytes32 | hash of the action to be checked
keccak256(abi.encode(target, value, signature, data, executionTime, withDelegatecall))

#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`true`| bytes32 | if underlying action of actionHash is queued

### isProposalOverGracePeriod
```solidity
  function isProposalOverGracePeriod(
    contract IAaveGovernanceV2 governance,
    uint256 proposalId
  ) external returns (bool)
```

Checks whether a proposal is over its grace period

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`governance` | contract IAaveGovernanceV2 | Governance contract
|`proposalId` | uint256 | Id of the proposal against which to test

#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`true`| contract IAaveGovernanceV2 | of proposal is over grace period

### GRACE_PERIOD
```solidity
  function GRACE_PERIOD(
  ) external returns (uint256)
```

Getter of grace period constant


#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`grace`|  | period in seconds

### MINIMUM_DELAY
```solidity
  function MINIMUM_DELAY(
  ) external returns (uint256)
```

Getter of minimum delay constant


#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`minimum`|  | delay in seconds

### MAXIMUM_DELAY
```solidity
  function MAXIMUM_DELAY(
  ) external returns (uint256)
```

Getter of maximum delay constant


#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`maximum`|  | delay in seconds

### queueTransaction
```solidity
  function queueTransaction(
    address target,
    uint256 value,
    string signature,
    bytes data,
    uint256 executionTime,
    bool withDelegatecall
  ) external returns (bytes32)
```

Function, called by Governance, that queue a transaction, returns action hash

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`target` | address | smart contract target
|`value` | uint256 | wei value of the transaction
|`signature` | string | function signature of the transaction
|`data` | bytes | function arguments of the transaction or callData if signature empty
|`executionTime` | uint256 | time at which to execute the transaction
|`withDelegatecall` | bool | boolean, true = transaction delegatecalls the target, else calls the target


### executeTransaction
```solidity
  function executeTransaction(
    address target,
    uint256 value,
    string signature,
    bytes data,
    uint256 executionTime,
    bool withDelegatecall
  ) external returns (bytes)
```

Function, called by Governance, that cancels a transaction, returns the callData executed

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`target` | address | smart contract target
|`value` | uint256 | wei value of the transaction
|`signature` | string | function signature of the transaction
|`data` | bytes | function arguments of the transaction or callData if signature empty
|`executionTime` | uint256 | time at which to execute the transaction
|`withDelegatecall` | bool | boolean, true = transaction delegatecalls the target, else calls the target


### cancelTransaction
```solidity
  function cancelTransaction(
    address target,
    uint256 value,
    string signature,
    bytes data,
    uint256 executionTime,
    bool withDelegatecall
  ) external returns (bytes32)
```

Function, called by Governance, that cancels a transaction, returns action hash

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`target` | address | smart contract target
|`value` | uint256 | wei value of the transaction
|`signature` | string | function signature of the transaction
|`data` | bytes | function arguments of the transaction or callData if signature empty
|`executionTime` | uint256 | time at which to execute the transaction
|`withDelegatecall` | bool | boolean, true = transaction delegatecalls the target, else calls the target


## Events
### NewPendingAdmin
```solidity
  event NewPendingAdmin(
    address newPendingAdmin
  )
```

emitted when a new pending admin is set

#### Parameters:
| Name                           | Type          | Description                                    |
| :----------------------------- | :------------ | :--------------------------------------------- |
|`newPendingAdmin`| address | address of the new pending admin

### NewAdmin
```solidity
  event NewAdmin(
    address newAdmin
  )
```

emitted when a new admin is set

#### Parameters:
| Name                           | Type          | Description                                    |
| :----------------------------- | :------------ | :--------------------------------------------- |
|`newAdmin`| address | address of the new admin

### NewDelay
```solidity
  event NewDelay(
    uint256 delay
  )
```

emitted when a new delay (between queueing and execution) is set

#### Parameters:
| Name                           | Type          | Description                                    |
| :----------------------------- | :------------ | :--------------------------------------------- |
|`delay`| uint256 | new delay

### QueuedAction
```solidity
  event QueuedAction(
    bytes32 actionHash,
    address target,
    uint256 value,
    string signature,
    bytes data,
    uint256 executionTime,
    bool withDelegatecall
  )
```

emitted when a new (trans)action is Queued.

#### Parameters:
| Name                           | Type          | Description                                    |
| :----------------------------- | :------------ | :--------------------------------------------- |
|`actionHash`| bytes32 | hash of the action
|`target`| address | address of the targeted contract
|`value`| uint256 | wei value of the transaction
|`signature`| string | function signature of the transaction
|`data`| bytes | function arguments of the transaction or callData if signature empty
|`executionTime`| uint256 | time at which to execute the transaction
|`withDelegatecall`| bool | boolean, true = transaction delegatecalls the target, else calls the target

### CancelledAction
```solidity
  event CancelledAction(
    bytes32 actionHash,
    address target,
    uint256 value,
    string signature,
    bytes data,
    uint256 executionTime,
    bool withDelegatecall
  )
```

emitted when an action is Cancelled

#### Parameters:
| Name                           | Type          | Description                                    |
| :----------------------------- | :------------ | :--------------------------------------------- |
|`actionHash`| bytes32 | hash of the action
|`target`| address | address of the targeted contract
|`value`| uint256 | wei value of the transaction
|`signature`| string | function signature of the transaction
|`data`| bytes | function arguments of the transaction or callData if signature empty
|`executionTime`| uint256 | time at which to execute the transaction
|`withDelegatecall`| bool | boolean, true = transaction delegatecalls the target, else calls the target

### ExecutedAction
```solidity
  event ExecutedAction(
    bytes32 actionHash,
    address target,
    uint256 value,
    string signature,
    bytes data,
    uint256 executionTime,
    bool withDelegatecall,
    bytes resultData
  )
```

emitted when an action is Cancelled

#### Parameters:
| Name                           | Type          | Description                                    |
| :----------------------------- | :------------ | :--------------------------------------------- |
|`actionHash`| bytes32 | hash of the action
|`target`| address | address of the targeted contract
|`value`| uint256 | wei value of the transaction
|`signature`| string | function signature of the transaction
|`data`| bytes | function arguments of the transaction or callData if signature empty
|`executionTime`| uint256 | time at which to execute the transaction
|`withDelegatecall`| bool | boolean, true = transaction delegatecalls the target, else calls the target
|`resultData`| bytes | the actual callData used on the target

