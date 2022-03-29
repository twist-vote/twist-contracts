import { ethers, deployments, getNamedAccounts } from "hardhat";
import { Signer, Contract, BigNumber } from "ethers";

import { ContractId, EthereumAddress } from "./types";
import { deployContract } from "./contracts";
import {
  MockERC20,
  MockTokemakManager,
  MockTokemakRewards,
  MockOnChainVoteL1,
  TokemakPool,
  FeeDistribution,
} from "../compiled-types";

/**
 * Reactor Keys: You can query this using the getSystemVotes() from the contract and doing an ethers.utils.parseBytes32String() on the resulting data.votes[].reactorKey's
 */

export const deployMockFeeDistribution = async (
  bidAsset?: EthereumAddress
): Promise<FeeDistribution> => {
  return deployContract<FeeDistribution>(ContractId.FeeDistribution, [bidAsset]);
};

// Tokemak Token (TOKE: governance token of tokemak.xyz)
export const deployMockTokemakToken = async () => {
  return deployContract<MockERC20>(ContractId.TokemakToken, []);
};
export const getTokemakTokenDeployment = async (address?: EthereumAddress): Promise<MockERC20> => {
  if (address == undefined && !(await deployments.getOrNull(ContractId.TokemakToken))) {
    await deployMockTokemakToken();
  }

  return (await ethers.getContractAt(
    ContractId.TokemakToken,
    address || (await deployments.get(ContractId.TokemakToken)).address
  )) as MockERC20;
};

// Tokemak tToken (TokeVotePool)
export const deployMockTokemakTToken = async () => {
  return deployContract<MockERC20>(ContractId.TokemakTToken, []);
};
export const getTokemakTTokenDeployment = async (address?: EthereumAddress): Promise<MockERC20> => {
  let contract;
  if (address == undefined && !(await deployments.getOrNull(ContractId.TokemakTToken))) {
    contract = await deployMockTokemakTToken();
  }
  console.log(contract?.address, await deployments.getOrNull(ContractId.TokemakTToken));
  return (await ethers.getContractAt(
    ContractId.TokemakTToken,
    address ||
      (
        await deployments.getOrNull(ContractId.TokemakTToken)
      )?.address ||
      contract?.address ||
      ""
  )) as MockERC20;
};

// TokemakManager
export const deployMockTokemakManager = async () => {
  return deployContract<MockTokemakManager>(ContractId.TokemakManager, []);
};
export const getTokemakManagerDeployment = async (
  address?: EthereumAddress
): Promise<MockTokemakManager> => {
  if (address == undefined && !(await deployments.getOrNull(ContractId.TokemakManager))) {
    await deployMockTokemakManager();
  }
  return (await ethers.getContractAt(
    ContractId.TokemakManager,
    address || (await deployments.get(ContractId.TokemakManager)).address
  )) as MockTokemakManager;
};

// TokemakReward
export const deployMockTokemakReward = async (TOEK?: EthereumAddress) => {
  return deployContract<MockTokemakRewards>(ContractId.TokemakRewards, [TOEK]);
};
export const getTokemakRewardsDeployment = async (
  address?: EthereumAddress,
  TOEK?: EthereumAddress
): Promise<MockTokemakRewards> => {
  if (address == undefined && !(await deployments.getOrNull(ContractId.TokemakRewards))) {
    await deployMockTokemakReward(TOEK);
  }
  return (await ethers.getContractAt(
    ContractId.TokemakRewards,
    address || (await deployments.get(ContractId.TokemakRewards)).address
  )) as MockTokemakRewards;
};

// OnChainVoteL1
const deployTokemakOnChainVoteL1 = async () => {
  return deployContract<MockOnChainVoteL1>(ContractId.TokeOnChainVoteL1, []);
};
export const getTokeOnChainVoteL1Deployment = async (
  address?: EthereumAddress
): Promise<MockOnChainVoteL1> => {
  if (address == undefined && !(await deployments.getOrNull(ContractId.TokeOnChainVoteL1))) {
    await deployTokemakOnChainVoteL1();
  }

  return (await ethers.getContractAt(
    ContractId.TokeOnChainVoteL1,
    address || (await deployments.get(ContractId.TokeOnChainVoteL1)).address
  )) as MockOnChainVoteL1;
};

/// Core OnChainVoteL1
const deployCoreOnChainVoteL1 = async () => {
  return deployContract<MockOnChainVoteL1>(ContractId.CoreOnChainVoteL1, []);
};
export const getCoreOnChainVoteL1Deployment = async (
  address?: EthereumAddress
): Promise<MockOnChainVoteL1> => {
  if (address == undefined && !(await deployments.getOrNull(ContractId.CoreOnChainVoteL1))) {
    await deployCoreOnChainVoteL1();
  }

  return (await ethers.getContractAt(
    ContractId.CoreOnChainVoteL1,
    address || (await deployments.get(ContractId.CoreOnChainVoteL1)).address
  )) as MockOnChainVoteL1;
};

/// TokemakPool
export const deployMockTokemakContracts = async (Toke: EthereumAddress) => {
  const tokemakManager = await deployMockTokemakManager();
  const tokemakRewards = await deployMockTokemakReward(Toke);
  const tokeOnChainVoteL1 = await deployTokemakOnChainVoteL1();
  const coreOnChainVoteL1 = await deployCoreOnChainVoteL1();

  return { tokemakManager, tokemakRewards, tokeOnChainVoteL1, coreOnChainVoteL1 };
};
export const deployMockTokemakPool = async (
  feeDistributor: string,
  TToke: string,
  Toke: string,
  bid: string,
  tokemakParams: any
) => {
  return deployContract<TokemakPool>(ContractId.TokemakPool, [
    "Bribe-TokemakPool",
    "BRTP",
    feeDistributor,
    TToke,
    Toke,
    bid,
    [
      tokemakParams.tokemakManager.address,
      tokemakParams.tokemakRewards.address,
      tokemakParams.tokeOnChainVoteL1.address,
      tokemakParams.coreOnChainVoteL1.address,
    ],
  ]);
};
