import { ethers } from "hardhat";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ContractId } from "../helper/types";

const deployAaveVault: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {
    deployments: { deploy, get },
    getNamedAccounts,
    companionNetworks,
  } = hre;

  const mockAave = await ethers.getContract("MockAave");
  const mockStkAave = await ethers.getContract("MockStkAave");
  const gauge = await ethers.getContract("Gauge");

  const { deployer } = await getNamedAccounts();

  await deploy("AaveVault", {
    from: deployer,
    args: [[mockAave.address, mockStkAave.address], gauge.address],
    log: true,
  });
};

export default deployAaveVault;
deployAaveVault.tags = ["AaveVault"];
deployAaveVault.dependencies = ["MockAave", "MockStkAave", "Gauge"];
