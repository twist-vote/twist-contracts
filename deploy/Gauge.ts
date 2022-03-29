import { ethers } from "hardhat";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ContractId } from "../helper/types";

const deployGauge: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {
    deployments: { deploy, get },
    getNamedAccounts,
    companionNetworks,
  } = hre;

  const bribeToken = await ethers.getContract("BribeToken");
  // use a mock token for bidAsset
  const bidAsset = await ethers.getContract("BidAsset");
  const { deployer } = await getNamedAccounts();

  await deploy("Gauge", {
    from: deployer,
    args: [bribeToken.address, bidAsset.address],
    log: true,
  });
};

export default deployGauge;
deployGauge.tags = ["Gauge"];
deployGauge.dependencies = ["BribeToken", "BidAsset"];
