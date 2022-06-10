pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./interfaces/IProposalPrice.sol";

/// @title ProposalPrice
/// @notice This contract is used by vault staker to set up a price on the creation of proposals
abstract contract ProposalPrice is IProposalPrice {
    using SafeERC20 for IERC20;

    /// @notice mapping of depositors to prices
    mapping(address => uint256[3]) public pricers;

    /// @notice list of historical depositors
    address[] depositors;
    // executor address used to pass proposals
    address[3] executors;

    IERC20 receiptToken;

    /// @notice
    /// @param receiptToken_ receipt tokens to compute the "voting power" for each pricer
    /// @param executors_ protocols sometimes have different executors (time till end of vote), logically the longer the executor the more expensive it is
    constructor(IERC20 receiptToken_, address[3] memory executors_) {
        receiptToken = receiptToken_;
        executors = executors_;
    }

    /// @notice let a user set his price to let Bribe pass new proposal with his voting power
    /// @param prices (uint256) consider at most 3 kind of executor / protocol, from shorter to longer
    function setPrice(uint256[3] calldata prices, address to) external override {
        pricers[to] = prices;

        emit PriceSubmitted(prices, to);
    }

    /// @notice getPrice for each executors
    function getPrices() public view returns (uint256[3] memory) {
        uint256 totalVotingPower = 0;
        uint256[3] memory totalPrice = [uint256(0), uint256(0), uint256(0)];
        for (uint256 i = 0; i < depositors.length; i++) {
            // check receipt token balance
            uint256 weight = receiptToken.balanceOf(depositors[i]);
            if (weight == 0) {
                continue;
            }
            totalVotingPower += receiptToken.balanceOf(depositors[i]);
            totalPrice[0] += pricers[depositors[i]][0] * weight;
            totalPrice[1] += pricers[depositors[i]][1] * weight;
            totalPrice[2] += pricers[depositors[i]][2] * weight;
        }
        return [
            totalPrice[0] / totalVotingPower,
            totalPrice[1] / totalVotingPower,
            totalPrice[2] / totalVotingPower
        ];
    }
}
