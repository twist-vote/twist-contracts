# Bribe Protocol

Bribe creates DAO infrastructure tooling to reward protocol participation. We aim to revolutionize dGov with incentivized governance.

Bribe protocol is made of 2 main products:

- Pools
- Pots

## Pools

Pools aggregate voting power from multiple stakers into one contract. That voting power can later on be bribed in order to create proposals and/or vote on proposals.

### Pool Architecture

![image](https://raw.githubusercontent.com/bribeprotocol/bribe-v2/main/docs/images/Pool.png?token=GHSAT0AAAAAABOWRQDXSEJEJRZ7J62PYZTMYSOY7ZA)

## Pots

Bribe is offering an incentive marketplace in the form of pots.

Pots are airdrop that are built out of users behaviour.

For example: A new protocol want to incentivize new users to try it.

- The team will usually promise an airdrop, the condition for the airdrop are unknown, when is the snapshot happening? how are shares distributed? What will be the total amount?
- That team could instead submit an incentive on the Bribe pots marketplace, defining the airdrop conditions.
- It will enter the SC address that needs incentives, ABI is fetched from that contract, it will then select an event from that ABI and describe which parameters needs to be completed to be elligible for this airdrop.
- Enter a description for this airdrop, the total amount of token to be distributed and an expiration date after which the airdrop will be built and distributed by Bribe bots.
- Eventually exclude some addresses.

Such implementation is powerful because it opens permissionless incentives both for instigator and instigated.

Because Bribe pots is designed as a marketplace, anyone can visit the pots page and see where he is elligible for rewards. An account can claim its rewards all at once, receiving a range of token.

### Features

- To create a pots, point to a proposal ID and an executing contract.
- Assign a bounty to an action that needs to be taken on-chain
- Assign an expiration time to the pots, after what the bounty will be claimable by the addresses that have executed the underlying action.
- Eventually blacklist some addresses from your bounty program
