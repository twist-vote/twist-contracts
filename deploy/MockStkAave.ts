import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployMockStkAave: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {
    deployments: { deploy, get },
    getNamedAccounts,
    companionNetworks,
  } = hre;
  const { deployer } = await getNamedAccounts();

  await deploy("MockStkAave", {
    from: deployer,
    args: [],
    log: true,
  });
};

export default deployMockStkAave;
deployMockStkAave.tags = ["MockStkAave"];
