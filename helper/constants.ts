import { ethers } from "hardhat";

interface IDeployParameters {
  [key: string]: any;
}

export default Object.freeze({
  mainnet: {
    aave: "0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9",
    stkAave: "0x4da27a545c0c5b758a6ba100e3a049001de870f5",
    // USDC
    bidAsset: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
    aaveGovernance: "0xEC568fffba86c094cf06b22134B23074DFE2252c",
    usdc: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",

    // tokemak
    TokemakManager: "0xA86e412109f77c45a3BC1c5870b880492Fb86A14",
    TokemakRewards: "0x79dD22579112d8a5F7347c5ED7E609e60da713C5",
    TokeOnChainVoteL1: "0x43094eD6D6d214e43C31C38dA91231D2296Ca511",
    CoreOnChainVoteL1: ethers.constants.AddressZero,
    TokemakTToken: "0xa760e26aA76747020171fCF8BdA108dFdE8Eb930", // TokemakTokePool
    TokemakToken: "0x2e9d63788249371f1DFC918a52f8d799F4a38C94",
  },
  localhost: {
    aave: "0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9",
    stkAave: "0x4da27a545c0c5b758a6ba100e3a049001de870f5",
    // USDC
    bidAsset: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
    aaveGovernance: "0xEC568fffba86c094cf06b22134B23074DFE2252c",
    usdc: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",

    // tokemak
    TokemakManager: "0xA86e412109f77c45a3BC1c5870b880492Fb86A14",
    TokemakRewards: "0x79dD22579112d8a5F7347c5ED7E609e60da713C5",
    TokeOnChainVoteL1: "0x43094eD6D6d214e43C31C38dA91231D2296Ca511",
    CoreOnChainVoteL1: ethers.constants.AddressZero,
    TokemakTToken: "0xa760e26aA76747020171fCF8BdA108dFdE8Eb930", // TokemakTokePool
    TokemakToken: "0x2e9d63788249371f1DFC918a52f8d799F4a38C94",
  },
  kovan: {
    aave: "0xb597cd8d3217ea6477232f9217fa70837ff667af",
    stkAave: "0xf2fbf9a6710afda1c4aab2e922de9d69e0c97fd2",
    // WETH address
    bidAsset: "0xd0A1E359811322d97991E03f863a0C30C2cF029C",
    aaveGovernance: "0xc2ebab3bac8f2f5028f5c7317027a41ebfca31d2",
    usdc: "0xd0A1E359811322d97991E03f863a0C30C2cF029C",
  },
  rinkeby: {
    // tokemak
    TokemakManager: "0xA86e412109f77c45a3BC1c5870b880492Fb86A14",
    TokemakRewards: "0x79dD22579112d8a5F7347c5ED7E609e60da713C5",
    TokeOnChainVoteL1: "0x43094eD6D6d214e43C31C38dA91231D2296Ca511",
    CoreOnChainVoteL1: ethers.constants.AddressZero,
    TokemakTToken: "0xa760e26aA76747020171fCF8BdA108dFdE8Eb930", // TokemakTokePool
    TokemakToken: "0x2e9d63788249371f1DFC918a52f8d799F4a38C94",
  },
  hardhat: {
    // tokemak
    TokemakManager: "0xA86e412109f77c45a3BC1c5870b880492Fb86A14",
    TokemakRewards: "0x79dD22579112d8a5F7347c5ED7E609e60da713C5",
    TokeOnChainVoteL1: "0x43094eD6D6d214e43C31C38dA91231D2296Ca511",
    CoreOnChainVoteL1: ethers.constants.AddressZero,
    TokemakTToken: "0xa760e26aA76747020171fCF8BdA108dFdE8Eb930", // TokemakTokePool
    TokemakToken: "0x2e9d63788249371f1DFC918a52f8d799F4a38C94",
  },
}) as IDeployParameters;
