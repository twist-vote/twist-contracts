# Twist Protocol

Twist creates DAO infrastructure tooling to reward protocol participation. We aim to revolutionize dGov with incentivized governance.

Twist protocol is made of 2 main products:

- Pots
- Coalitions

## Pots

Pots are incentives applied to proposals either onchain or offchain ([Snapshot](https://snapshot.org)).  
Imagine a proposal that has 2 possible outcome, ie accepted or rejected. A pot can be created for this proposal, this pot will accept incentives for both outcome.  
Anyone can deposit an amount of token for either of these outcome, ie if 10 accounts deposit 100 Twists to the accepted outcome, Voters who voted for this outcome (accepted) will have 1000 Twist available for claim.

## Coalitions

Coalitions aggregate voting power from multiple stakers into one contract.  
Coalitions offer a stake and forget service to stakers, Twist bots will oversee existing pots and direct pool votes in order to extract the most rewards for stakers.
Coalitions voting power can also be used to create proposals onchain, ie Aave requires 80,000 Aave in order to pass proposal onchain. A few wallets can provide that amount of token, by aggregating aave tokens from multiple account into one contract, Coalitions will eventually be able to create proposals in exchange for a fee defined by stakers. We could have a scenario where someone would pay ~10,000 Twist to stakers to pass a proposal onchain.

## Bots

Bots are server provided by the Twist DAO. They are a central entity to Twist.  
Bots have 3 important responsabilities in the protocol:

- automate voting accross Coalitions by overseeing pots incentives. ie if an incentive exist for the accepted outcome on a snapshot proposal, the bots will automatically use the voting power on the according pool and vote "yes" to make all stakers in this pool elligible for the reward.
- automate merkleroot generation, to make pots rewards claimable by voters, an airdrop needs to be created. Bots oversee all voters on a proposal and will create the merkleroot accordingly to make it possible for each voters to claim their fair amount of rewards.
- automate pot rewards accumulation on the gauge contract aka claim on the pots and send the amount to the gauge for pool stakers to reclaim their rewards amount later on.

### Twist Architecture

![image](https://raw.githubusercontent.com/Twistprotocol/Twist-v2/main/docs/images/Twist-diagram.png?token=GHSAT0AAAAAABOWRQDXC67OTQKH3BTYIMXAYSX6DJQ)
