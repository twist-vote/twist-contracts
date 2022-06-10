pragma solidity >=0.6.0;

/// @title IProposalPrice
interface IProposalPrice {
    event PriceSubmitted(uint256[3] prices, address from);

    function setPrice(uint256[3] calldata prices, address to) external;
}
