import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ContractId } from "../helper/types";

const deployGauge: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {
    deployments: { deploy, get },
    getNamedAccounts,
    companionNetworks,
  } = hre;
  const { deployer } = await getNamedAccounts();

  const bribeToken = await companionNetworks["rinkeby"].deployments.get("BribeToken");

  await deploy(ContractId.Gauge, {
    from: deployer,
    args: [bribeToken.address],
    log: true,
  });
};

export default deployGauge;
deployGauge.tags = [ContractId.Gauge];
