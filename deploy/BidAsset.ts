import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployBidAsset: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {
    deployments: { deploy, get },
    getNamedAccounts,
    companionNetworks,
  } = hre;
  const { deployer } = await getNamedAccounts();

  await deploy("BidAsset", {
    from: deployer,
    args: [],
    log: true,
  });
};

export default deployBidAsset;
deployBidAsset.tags = ["BidAsset"];
