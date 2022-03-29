import { Inbox__factory, networks, BridgeHelper, OutgoingMessageState } from "arb-ts";
import { parseEther } from "ethers/lib/utils";
import { ethers, getChainId, getNamedAccounts } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  // console.log(networks[await getChainId()], await getChainId());
  const inbox = Inbox__factory.connect(
    networks[await getChainId()].ethBridge!.inbox,
    ethers.provider
  );
  console.log(deployer.address);
  const ticket = await (
    await inbox.connect(deployer).depositEth(parseEther("0.001"), { value: parseEther("0.2") })
  ).wait();
}

main()
  .then((_) => console.log("hey"))
  .catch((error) => console.error(error));
