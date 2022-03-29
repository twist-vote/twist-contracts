pragma solidity ^0.8.4;

import "../BribePots.sol";
import "../Vault.sol";
import "../ProposalPrice.sol";
import "./interfaces/IGovernorBravo.sol";
import "../interfaces/IGaugeSnapshot.sol";
import "../interfaces/IVote.sol";

contract CompoundVote is BribePots, ProposalPrice, IVote {
    using SafeERC20 for IERC20;
    IGaugeSnapshot public immutable gauge;
    IGovernorBravo public immutable governorBravo;
    Vault public immutable vault;

    constructor(
        IERC20 bidAsset_,
        IGaugeSnapshot gauge_,
        Vault compoundVault_,
        IGovernorBravo governorBravo_,
        address[3] memory executors
    ) BribePots(bidAsset_) ProposalPrice(IERC20(address(gauge_)), executors) {
        gauge = gauge_;
        vault = compoundVault_;
        governorBravo = governorBravo_;
        bidAsset_.safeIncreaseAllowance(
            address(gauge_),
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        );
    }

    function vote(uint256 proposalID) external onlyActiveProposals(proposalID) {
        Outcome memory outcome = bids[proposalID];
        uint256 bidAmount = outcome.yay + outcome.nay;
        gauge.accrueBidReward(address(vault.govTokens(0)), bidAmount);
        // in case of equality, yay wins
        bool support = outcome.yay >= outcome.nay ? true : false;
        governorBravo.castVote(proposalID, support);

        emit Voted(proposalID, support);
    }

    function createProposal(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) external returns (uint256 proposalId) {
        uint256 price = 0;
        // find executor index
        for (uint8 i = 0; i < 3; i++) {
            if (executors[i] == address(governorBravo)) {
                price = getPrices()[i];
            }
        }
        require(price != 0, "NO_PRICE_SET");

        bidAsset.safeTransferFrom(msg.sender, address(this), price);

        proposalId = governorBravo.propose(targets, values, signatures, calldatas, description);

        emit ProposalCreated(proposalId);
    }
}
