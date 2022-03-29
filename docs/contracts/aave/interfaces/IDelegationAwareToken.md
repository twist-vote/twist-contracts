


## Functions
### delegate
```solidity
  function delegate(
    address delegatee,
    enum IDelegationAwareToken.DelegationType delegationType
  ) external
```

delegates the specific power to a delegatee

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`delegatee` | address | the user which delegated power has changed
|`delegationType` | enum IDelegationAwareToken.DelegationType | the type of delegation (VOTING_POWER, PROPOSITION_POWER)


### delegateAll
```solidity
  function delegateAll(
    address delegatee
  ) external
```

delegates all the powers to a specific user

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`delegatee` | address | the user to which the power will be delegated


### getDelegatee
```solidity
  function getDelegatee(
    address delegator
  ) external returns (address)
```

returns the delegatee of an user

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`delegator` | address | the address of the delegator


### getPowerCurrent
```solidity
  function getPowerCurrent(
    address user
  ) external returns (uint256)
```

returns the current delegated power of a user. The current power is the
power delegated at the time of the last snapshot

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`user` | address | the user


### getPowerAtBlock
```solidity
  function getPowerAtBlock(
    address user
  ) external returns (uint256)
```

returns the delegated power of a user at a certain block

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`user` | address | the user


### totalSupplyAt
```solidity
  function totalSupplyAt(
  ) external returns (uint256)
```

returns the total supply at a certain block number



## Events
### DelegateChanged
```solidity
  event DelegateChanged(
    address delegator,
    address delegatee,
    enum IDelegationAwareToken.DelegationType delegationType
  )
```

emitted when a user delegates to another

#### Parameters:
| Name                           | Type          | Description                                    |
| :----------------------------- | :------------ | :--------------------------------------------- |
|`delegator`| address | the delegator
|`delegatee`| address | the delegatee
|`delegationType`| enum IDelegationAwareToken.DelegationType | the type of delegation (VOTING_POWER, PROPOSITION_POWER)

### DelegatedPowerChanged
```solidity
  event DelegatedPowerChanged(
    address user,
    uint256 amount,
    enum IDelegationAwareToken.DelegationType delegationType
  )
```

emitted when an action changes the delegated power of a user

#### Parameters:
| Name                           | Type          | Description                                    |
| :----------------------------- | :------------ | :--------------------------------------------- |
|`user`| address | the user which delegated power has changed
|`amount`| uint256 | the amount of delegated power for the user
|`delegationType`| enum IDelegationAwareToken.DelegationType | the type of delegation (VOTING_POWER, PROPOSITION_POWER)

