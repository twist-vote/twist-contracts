import { ethers } from "hardhat";
import { Gauge } from "../compiled-types";

describe("Events", function () {
  let gauge: Gauge;
  before(async function () {
    gauge = await ethers.getContract("Gauge");
    console.log(gauge.address);
  });

  it("list users in gauge", async () => {});
});
