pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./ProposalBlocker.sol";

/// @title BribePots
/// @notice BribePots abstract contract, to be extended by pools who support bilateral proposals.
abstract contract BribePots is ProposalBlocker {
    using SafeERC20 for IERC20;

    IERC20 bidAsset;

    mapping(uint256 => Outcome) public bids;

    struct Outcome {
        uint256 yay;
        uint256 nay;
    }

    constructor(IERC20 bidAsset_) {
        bidAsset = bidAsset_;
    }

    /// @notice Bid on bilateral proposals, choose a side and increase the amount bidded, the side with the highest amount wins the vote.
    /// @param proposalID proposal id to bid on
    /// @param amount to bid
    /// @param support on which side the bid will be active
    function bid(
        uint256 proposalID,
        uint256 amount,
        bool support
    ) external onlyActiveProposals(proposalID) {
        bidAsset.safeTransferFrom(msg.sender, address(this), amount);
        Outcome storage outcome = bids[proposalID];
        support ? outcome.yay += amount : outcome.nay += amount;
    }
}
