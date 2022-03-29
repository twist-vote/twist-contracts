pragma solidity >0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IGauge.sol";
import "./interfaces/IGaugeSnapshot.sol";
import "hardhat/console.sol";

/// @title ReceiptToken
/// @notice Receipt token used accross protocols that bribe integrate, ping the gauge before and after a token transfer
contract ReceiptToken is ERC20, Ownable {
    IGauge public gauge;
    /// @notice the counterpart this receipt token represent
    IERC20 public underlyingToken;

    // ReceiptToken can represent 2 underlying tokens
    mapping(address => uint256[2]) public tokenAmounts;

    /// @notice
    /// @param name_ Receipt token name
    /// @param symbol_ Receipt token symbol
    /// @param underlying_ 1:1 governance token this receipt token represent
    /// @param gauge_ Gauge contract to keep accounting with
    constructor(
        string memory name_,
        string memory symbol_,
        IERC20 underlying_,
        IGauge gauge_
    ) Ownable() ERC20(name_, symbol_) {
        // a pool always initialize its own receipt token
        // pool = IPool(msg.sender);
        gauge = gauge_;
        underlyingToken = underlying_;
    }

    /// @param user Account to mint token to
    /// @param amount Amount of token to mint
    function mint(address user, uint256 amount) external onlyOwner {
        _mint(user, amount);
    }

    /// @param user Account to burn token to
    /// @param amount Amount of token to burn
    function burn(address user, uint256 amount) external onlyOwner {
        _burn(user, amount);
    }

    /// @notice AccumulateBidRewards before a token transfer, (leave a snapshot before updating user amount)
    /// @param from Sender
    /// @param to Receiptor
    /// @param amount Amount being transfered
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        accumulateBidRewards(from, to);
    }

    /// @notice accumulate bribe and staking rewards, creates a checkpoint on the gauge before updating gauges balance
    /// @param from Sender
    /// @param to Receiptor
    /// @param amount Amount being transfered
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if (from != address(0)) {
            gauge.accumulateRewards(address(underlyingToken), from);
        }
        if (to != address(0)) {
            gauge.accumulateRewards(address(underlyingToken), to);
        }
    }

    /// @notice internal utility function to accumulate bid rewards
    /// @param from Sender
    /// @param to Receiptor
    function accumulateBidRewards(address from, address to) internal {
        if (from != address(0)) {
            IGaugeSnapshot(address(gauge)).accumulateBidRewards(address(underlyingToken), from);
        }
        if (to != address(0)) {
            IGaugeSnapshot(address(gauge)).accumulateBidRewards(address(underlyingToken), to);
        }
    }
}
