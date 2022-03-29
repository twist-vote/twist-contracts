pragma solidity >=0.6.0;

interface IVote {
    event Voted(uint256 proposalID, bool outcome);
    event ProposalCreated(uint256 proposalID);
}
