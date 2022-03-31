### Bribe pots

Bribe pots is a generalized incentive mecanism. Pots are designed to incentivize any action taken on-chain.

## Pots v1 features

- One pots Factory create one pots per protocol, referrencing each protocol by name eg "qidao"
- Each pots created can manage multiple airdrop/incentive, listing them by id, this id is an integer.
- Pots and incentives are not permissionless, they can only be created by an admin.
- Pots are not free to use, fees are collected. Fees are collected if the incentive is successful when rewards are claimed, but also if the incentive is cancelled, when depositted bounty asset are withdrawn.
- Incentive can be blocked by the admin, when an incentive is blocked, depositors are refunded.
- Incentive needs a minimum amount deposited to be created.
- All Incentive under one pot have the same lifetime, no matter the incentive. So each incentive under qiDao will be created for the same amount of time, no matter the nature of the incentive.
- Merkle proof are updated by an admin, when the incentive lifetime has expired.
- Each alligible account for an incentive has 30 days to claims the bounty rewards. After which bounty is blocked and can only be claimed by depositors.
- Each incentive can have multiple incentivizers but only one bounty asset, ie one incentive created can have its bounty amount increased by different accounts, however the token used for this bounty is unique and shared by all incentive in the same pots (qidao pots will always use the same bid asset, for all its incentive).
- Each incentive can support an infinite number of outputs, output are caracterized by integers, eg for a bilateral proposal, output 0 is yay, output 1 is nay.

## Pots v2 features

- One pots factory create one pots per smart contract, referrencing each smart contract by its address.
- Each pots created is linked to one smart contract address, multiple different incentives can be created for one SC. If a pot target AaveGovernance SC, we can create incentive for each proposal and for each proposal output. So one pot is basically a list of incentives attached to one smart contract.
- The conditions to trigger an incentive are uploaded to ipfs in JSON format. So each incentive needs to referrence an ipfs hash. For example an incentive an a proposal for aave will have its conditions saved in ipfs.
- A specific format and list of conditions needs to respect a standard shared by each incentive, this standard will be designed thanks to contract ABI and events parameters.
- One asset supported per incentive, meaning one pot (which is a list of incentives attached to one SC) can support different bid asset, while each incentive will have only one bid asset.
- MerkleTrees are being built by bots, by reading the ipfs hash attached to each incentives and fetching the conditions from this hash. Thanks to a standard format, the bot will be able to build the merkletree autonomously with the informations stored on ipfs. Those info are immutable after the incentive creation, everything will be transparent and auditable by anyone.
- Because each incentives are built following a standard format, and via contracts ABI, the incentive creation can be made permissionless.
- MerkleTrees are updated to ipfs when ready, and incentive will refer that ipfs hash when rewards are ready to be dropped.
