import { ethers } from "hardhat";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ContractId } from "../helper/types";

const deployVote: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {
    deployments: { deploy, get },
    getNamedAccounts,
    companionNetworks,
  } = hre;

  const bribeToken = await ethers.getContract("BribeToken");
  const gauge = await ethers.getContract("Gauge");
  const aaveVault = await ethers.getContract("AaveVault");
  const { deployer } = await getNamedAccounts();

  await deploy("AaveVote", {
    from: deployer,
    args: [
      bribeToken.address,
      gauge.address,
      aaveVault.address,
      ethers.constants.AddressZero,
      [ethers.constants.AddressZero, ethers.constants.AddressZero, ethers.constants.AddressZero],
    ],
    log: true,
  });
};

export default deployVote;
deployVote.tags = ["AaveVote"];
deployVote.dependencies = ["Gauge", "MockAave", "BidAsset"];
