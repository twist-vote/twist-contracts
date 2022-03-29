export enum ContractId {
  Aave = "MockAave",
  AaveMIMBidHelperV1 = "AaveMIMBidHelperV1",
  AavePool = "AavePool",
  AaveWrapperToken = "AaveWrapperToken",
  BidAsset = "BidAsset",
  BribeStakeHelper = "BribeStakeHelper",
  BribeToken = "BribeToken",
  Dividend = "Dividends",
  Erc20 = "Erc20",
  FeeDistribution = "FeeDistribution",
  FeeToken = "FeeToken",
  Gauge = "Gauge",
  ReceiptToken = "ReceiptToken",
  MockAaveGovernanceWithTokens = "MockAaveGovernanceWithTokens",
  MockFeeDistributor = "MockFeeDistributor",
  MockPool = "MockPool",
  StkAave = "MockStkAave",
  StkAaveWrapperToken = "StkAaveWrapperToken",
  USDC = "USDC",

  // Tokemak
  CoreOnChainVoteL1 = "MockOnChainVoteL1",
  TokemakManager = "MockTokemakManager",
  TokemakPool = "TokemakPool",
  TokemakRewards = "MockTokemakRewards",
  TokemakToken = "MockTokeToken",
  TokemakTToken = "MockTokeVotePool",
  TokemakVote = "TokemakVote",
  TokeOnChainVoteL1 = "MockOnChainVoteL1",

  AaveVoteResolver = "AaveVoteResolver",
  AaveBoost = "AaveBoost",
}

export const PoolInfo = [
  // pool name, pool governance token symbol
  ["AavePool", "Aave"],
  ["TokemakPool", "TokemakTToken"],
];

export type EthereumAddress = string;
