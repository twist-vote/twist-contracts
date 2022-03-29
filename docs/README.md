# Bribe Protocol

Bribe creates DAO infrastructure tooling to reward protocol participation. We aim to revolutionize dGov with incentivized governance.

Bribe protocol is made of 2 main products:

- Pools
- Pots

## Pools

Pools aggregate voting power from multiple stakers into one contract. That voting power can later on be bribed in order to create proposals and/or vote on proposals.

### Pool Architecture

![image](https://raw.githubusercontent.com/bribeprotocol/bribe-v2/main/docs/images/Pool.png?token=GHSAT0AAAAAABOWRQDXZGURKJYFPLZGMRWWYSMM3CQ)

## Pots

The goal with pots is to make it easy for anyone to incentivize any actions that needs to be taken on-chain.

### Features

- To create a pots, point to a proposal ID and an executing contract.
- Assign a bounty to an action that needs to be taken on-chain
- Assign an expiration time to the pots, after what the bounty will be claimable by the addresses that have executed the underlying action.
- Eventually blacklist some addresses from your bounty program
