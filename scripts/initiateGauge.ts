import { parseEther } from "ethers/lib/utils";
import { ethers } from "hardhat";
import {} from "arb-ts";
import { Gauge, ReceiptToken } from "../compiled-types";

async function main() {
  const [deployer] = await ethers.getSigners();
  const gauge: Gauge = await ethers.getContract("Gauge");
  const receiptToken: ReceiptToken = await ethers.getContract("ReceiptToken");
  await gauge.add(receiptToken.address, 1);
  await gauge.setRewardsPerBlocks(parseEther("0.1"));
}
