pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title ProposalBlocker
/// @notice abstract contract to be extended by vote contract for each protocol, allow admin to block certain proposal ID
/// making them impossible to bid or vote on.
abstract contract ProposalBlocker is Ownable {
    mapping(uint256 => bool) public blocked;

    event BlockedProposal(uint256 proposalID);
    event UnBlockedProposal(uint256 proposalID);

    modifier onlyActiveProposals(uint256 proposalID) {
        require(blocked[proposalID] == false, "Proposal blocked");
        _;
    }

    /// @notice Block proposals, reserved for admin, should refund all active bidders
    /// @param proposalID proposal ID
    function blockProposal(uint256 proposalID) external onlyOwner {
        blocked[proposalID] = true;
        _afterProposalBlocked(proposalID);
        emit BlockedProposal(proposalID);
    }

    /// @notice Virtual function to be extended for refund
    /// @param proposalID Proposal ID
    function _afterProposalBlocked(uint256 proposalID) internal virtual {}

    /// @notice Un-Block a proposal, reserved for admin
    /// @param proposalID proposal to unlock
    function unBlockProposal(uint256 proposalID) external onlyOwner {
        blocked[proposalID] = false;
        _afterProposalUnBlocked(proposalID);
        emit UnBlockedProposal(proposalID);
    }

    function _afterProposalUnBlocked(uint256 proposalID) internal virtual {}
}
