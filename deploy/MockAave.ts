import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployMockAave: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {
    deployments: { deploy, get },
    getNamedAccounts,
    companionNetworks,
  } = hre;
  const { deployer } = await getNamedAccounts();

  await deploy("MockAave", {
    from: deployer,
    args: [],
    log: true,
  });
};

export default deployMockAave;
deployMockAave.tags = ["MockAave"];
