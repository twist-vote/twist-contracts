import { expect } from "chai";
import { formatEther, parseEther } from "ethers/lib/utils";
import { deployments, ethers, getChainId } from "hardhat";
import {
  AaveVault,
  AaveVote,
  BidAsset,
  BribeToken,
  ERC20,
  Gauge,
  MockAave,
  MockStkAave,
} from "../compiled-types";
import { advanceNBlocks } from "./utils";

describe("Deposit", function () {
  let vault: AaveVault;
  let mockAave: MockAave;
  let mockStkAave: MockStkAave;
  let bidAsset: BidAsset;
  let receipt0: ERC20;
  let receipt1: ERC20;
  let gauge: Gauge;
  let vote: AaveVote;

  let afterBlockDeposit = 0;
  before(async function () {
    const [account1] = await ethers.getSigners();
    if ((await getChainId()) == "31337") {
      await deployments.fixture();
    }
    // initialise gauge with rewards
    vault = await ethers.getContract("AaveVault");
    mockAave = await ethers.getContract("MockAave");
    mockStkAave = await ethers.getContract("MockStkAave");
    bidAsset = await ethers.getContract("BidAsset");

    receipt0 = await ethers.getContractAt("ERC20", await vault.receiptTokens(0));
    receipt1 = await ethers.getContractAt("ERC20", await vault.receiptTokens(0));

    gauge = await ethers.getContract("Gauge");
    vote = await ethers.getContract("AaveVote");

    // configure rewards for aave
    await gauge.add(
      await vault.govTokens(0),
      await vault.receiptTokens(0),
      1,
      ethers.constants.AddressZero
    );
    await gauge.add(await vault.govTokens(1), await vault.receiptTokens(1), 1, mockAave.address);

    await gauge.setRewardsPerBlocks(parseEther("0.1"));
    // configure rewards for stkAave
    await vault.setVoteContract(vote.address);
    // const bytes = gauge.interface.encodeFunctionData("accumulateReward", [
    //   account1.address,
    //   parseEther("1000"),
    //   parseEther("1000"),
    // ]);
    await mockAave.connect(account1).mintTo(account1.address, parseEther("1000"), {});
    await mockStkAave.connect(account1).mintTo(account1.address, parseEther("1000"), {});
    await bidAsset.connect(account1).mintTo(account1.address, parseEther("2000"), {});
  });

  it("deposit", async () => {
    const [account1] = await ethers.getSigners();

    await mockAave.approve(vault.address, parseEther("1000"));
    await vault.connect(account1).deposit(parseEther("1000"), account1.address, 0);

    await mockStkAave.approve(vault.address, parseEther("1000"));
    await vault.connect(account1).deposit(parseEther("1000"), account1.address, 1);
    afterBlockDeposit = await ethers.provider.getBlockNumber();
  });

  it("distribute bid rewards", async () => {
    // advanceNBlocks(100);
    const supply0 = await receipt0.totalSupply();
    const supply1 = await receipt1.totalSupply();
    const totalSupply = supply0.add(supply1);
    // imagine a bid of 2000 Bribe, we dispatch it accross the 2 govs tokens for aave pool
    await bidAsset.approve(gauge.address, parseEther("2000"));

    await gauge.accrueBidReward(
      await vault.govTokens(0),
      parseEther("1000").mul(supply0).div(totalSupply)
    );
    await gauge.accrueBidReward(
      await vault.govTokens(1),
      parseEther("1000").mul(supply1).div(totalSupply)
    );

    const pending = await gauge.pendingRewards();
    expect(pending).to.be.equal(parseEther("1000"));
  });

  it("distribute additional rewards", async () => {
    const [account1] = await ethers.getSigners();
    await mockAave.approve(gauge.address, parseEther("1000"));
    await mockAave.connect(account1).mintTo(account1.address, parseEther("1000"), {});
    await gauge.accrueAdditionalRewards(await vault.govTokens(1), parseEther("1000"));
    const result1 = await gauge.rewardBalanceOf(await vault.govTokens(1), account1.address);
    console.log("pending1: ", formatEther(result1.pending));
    console.log("additional pending1: ", formatEther(result1.additionalPending));
    const result0 = await gauge.rewardBalanceOf(await vault.govTokens(0), account1.address);
    console.log("pending0: ", formatEther(result0.pending));
  });
});
