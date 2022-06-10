pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "../BribePots.sol";
import "../Vault.sol";
import "../ProposalPrice.sol";
import "../interfaces/IGauge.sol";
import "../interfaces/IGaugeSnapshot.sol";
import {IAaveGovernanceV2} from "./interfaces/IAaveGovernanceV2.sol";
import {IExecutorWithTimelock} from "./interfaces/IExecutorWithTimelock.sol";

contract AaveVote is BribePots, ProposalPrice {
    using SafeERC20 for IERC20;
    IGaugeSnapshot public immutable gauge;
    Vault public immutable vault;
    IAaveGovernanceV2 public immutable aaveGovernance;

    event ProposalCreated(uint256 proposalID);

    constructor(
        IERC20 bidAsset_,
        IGaugeSnapshot gauge_,
        Vault aaveVault_,
        IAaveGovernanceV2 aaveGovernance_,
        address[3] memory executors
    ) BribePots(bidAsset_) ProposalPrice(IERC20(address(gauge_)), executors) {
        gauge = gauge_;
        vault = aaveVault_;
        aaveGovernance = aaveGovernance_;
        bidAsset_.safeIncreaseAllowance(
            address(gauge_),
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        );
    }

    /// @notice vote on a proposalID, dispatch bid rewards accross both governance tokens
    /// @param proposalID proposal to vote on
    function vote(uint256 proposalID) external onlyActiveProposals(proposalID) {
        Outcome memory outcome = bids[proposalID];
        uint256 bidAmount = outcome.yay + outcome.nay;
        uint256 balanceToken1 = vault.govTokens(0).balanceOf(address(vault));
        uint256 balanceToken2 = vault.govTokens(1).balanceOf(address(vault));
        uint256 totalBalance = balanceToken1 + balanceToken2;
        // accrue bid rewards for both tokens
        gauge.accrueBidReward(
            address(vault.govTokens(0)),
            bidAmount * (balanceToken1 / totalBalance)
        );
        gauge.accrueBidReward(
            address(vault.govTokens(1)),
            bidAmount * (balanceToken2 / totalBalance)
        );
        IAaveGovernanceV2(aaveGovernance).submitVote(
            proposalID,
            outcome.yay > outcome.nay ? true : false
        );
    }

    /// @notice use the pool voting power to create a new proposal
    /// the price to pay is set by vault stakers
    /// @param executor aave executor to use
    /// @param targets list of address to call
    /// @param values uint256[],
    /// @param signatures string[],
    /// @param calldatas bytes[],
    /// @param withDelegatecalls bool[],
    /// @param ipfsHash bytes32
    function createProposal(
        IExecutorWithTimelock executor,
        address[] calldata targets,
        uint256[] calldata values,
        string[] calldata signatures,
        bytes[] calldata calldatas,
        bool[] calldata withDelegatecalls,
        bytes32 ipfsHash
    ) external returns (uint256 proposalId) {
        uint256 price = 0;
        // find executor index
        for (uint8 i = 0; i < 3; i++) {
            if (executors[i] == address(executor)) {
                price = getPrices()[i];
            }
        }
        require(price != 0, "NO_PRICE_SET");

        bidAsset.safeTransferFrom(msg.sender, address(this), price);

        proposalId = aaveGovernance.create(
            executor,
            targets,
            values,
            signatures,
            calldatas,
            withDelegatecalls,
            ipfsHash
        );

        emit ProposalCreated(proposalId);
    }
}
