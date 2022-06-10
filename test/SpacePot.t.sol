pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "murky/Merkle.sol";

import "./MockERC20.sol";
import "../src/spacePot/SpacePot.sol";
import "../src/spacePot/SpacePotFactory.sol";

contract SpacePotTest is ISpacePot, Test {
    SpacePot spacePot = new SpacePot();
    // SpacePotFactory constant bpf = SpacePotFactory("0x660428626d4bAc1A7b1c619157e3205dAd540ad1");
    MockERC20 bidAsset = new MockERC20();

    Merkle m = new Merkle();

    bytes32[] leafs = new bytes32[](2);

    function setUp() public {
        leafs[0] = keccak256(abi.encodePacked(address(1), uint256(1)));
        leafs[1] = keccak256(abi.encodePacked(address(this), uint256(1)));
        bidAsset.setBalance(1 ether);
        spacePot.initialize("test", address(this), address(bidAsset));
    }

    function testDeposit() public {
        bidAsset.increaseAllowance(address(spacePot), 0.5 ether);
        spacePot.deposit(bytes32("1"), 1, address(this), 0.5 ether);
        // console.log(uint256(spacePot.getPotState(bytes32("1"), 1)));
    }

    function testSubmitMerkleRoot() public {
        bytes32 root = m.getRoot(leafs);

        bidAsset.increaseAllowance(address(spacePot), 0.5 ether);
        spacePot.deposit(bytes32("1"), 1, address(this), 0.5 ether);
        // submitting a totalVote of 3 so address(0) owns 1/3 of the airdrop
        spacePot.submitMerkleRoot(bytes32("1"), 1, root, bytes32("1"), 3);
    }

    // can't store them in the below function 🤷🏻‍♂️
    bytes32[] proposalIds;
    uint256[] optionIndexes;
    bytes32[][] proofs;
    address[] tos;
    uint256[] vps;

    function testWithdrawAfterExpiration() public {
        testSubmitMerkleRoot();
        vm.startPrank(address(1));
        uint256 rewards = spacePot.rewardsToClaim(
            bytes32("1"),
            1,
            m.getProof(leafs, 0),
            address(1),
            1
        );
        console.log(rewards);
        for (uint256 i = 0; i < 1; i++) {
            proposalIds.push(bytes32("1"));
            optionIndexes.push(1);
            proofs.push(m.getProof(leafs, 0));
            tos.push(address(1));
            vps.push(1);
        }
        spacePot.claimRewards(proposalIds, optionIndexes, proofs, tos, vps);
        vm.stopPrank();
        vm.warp(block.timestamp + 30 days);
        Leftovers memory leftovers = spacePot.leftoversToWithdraw(bytes32("1"), 1, address(this));
        console.log(leftovers.amount);
    }

    function deposit(
        bytes32 proposalId,
        uint256 optionIndex,
        address _to,
        uint128 _amount
    ) external override {}

    function claimRewards(
        bytes32[] calldata proposalId,
        uint256[] calldata optionIndex,
        bytes32[][] calldata proof,
        address[] calldata to,
        uint256[] calldata vp
    ) external override returns (uint256[] memory rewards) {}

    function initialize(
        string calldata _name,
        address _admin,
        address _bidAsset
    ) external override {}
}
