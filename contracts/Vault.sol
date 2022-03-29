pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IGauge.sol";
import "./interfaces/IVault.sol";
import "./interfaces/IERC20Details.sol";
import "./ReceiptToken.sol";

/// @title Vault abstract contract
/// @notice Abstract contract for underlying protocol vault implementation,
/// support up to 2 different governance tokens per vault
abstract contract Vault is IVault, Ownable {
    using SafeERC20 for IERC20;
    ///@notice the 2 govtokens, if second token == address(0), this vault only support 1 token
    IERC20[2] public govTokens;
    ///@notice up to 2 receipt tokens, always have a 1:1 governance token to receipt token
    ReceiptToken[2] public receiptTokens;

    IGauge public immutable gauge;

    /// @notice In order to mutualise code accross vault, each vault can initialize up to 2 governance tokens
    /// @param govTokens_ The governance tokens this vault will manage
    /// @param gauge_ The gauge this vault will communicate with
    constructor(IERC20[2] memory govTokens_, IGauge gauge_) {
        govTokens = govTokens_;
        gauge = gauge_;
        receiptTokens[0] = new ReceiptToken(
            string(abi.encodePacked("bribe-", IERC20Details(address(govTokens_[0])).name())),
            string(abi.encodePacked("br", IERC20Details(address(govTokens_[0])).symbol())),
            govTokens_[0],
            gauge_
        );
        // if second tokens is address(0), this vault does not have additional token
        if (address(govTokens_[1]) != address(0)) {
            receiptTokens[1] = new ReceiptToken(
                string(abi.encodePacked("bribe-", IERC20Details(address(govTokens_[1])).name())),
                string(abi.encodePacked("br", IERC20Details(address(govTokens_[1])).symbol())),
                govTokens_[1],
                gauge_
            );
        }
    }

    /// @notice Virtual function to take action after a deposit event
    /// @param amount Amount to deposit
    /// @param to Account to credit
    /// @param tokenIndex Which governance token index we deposit
    function _afterDeposit(
        uint256 amount,
        address to,
        uint8 tokenIndex
    ) internal virtual {}

    /// @notice deposit one of the governance token
    /// @param amount amount to deposit
    /// @param to account for which we deposit
    /// @param tokenIndex which of the 2 governance tokens we are depositing
    function deposit(
        uint256 amount,
        address to,
        uint8 tokenIndex
    ) external payable override {
        govTokens[tokenIndex].safeTransferFrom(msg.sender, address(this), amount);

        receiptTokens[tokenIndex].mint(to, amount);

        _afterDeposit(amount, to, tokenIndex);
    }

    /// @notice Virtual function to take action after a deposit event
    /// @param amount Amount to deposit
    /// @param to Account to credit
    /// @param tokenIndex Which governance token index we deposit
    function _afterWithdraw(
        uint256 amount,
        address to,
        uint8 tokenIndex
    ) internal virtual {}

    /// @notice withdraw one of the governance token
    /// @param amount amount to deposit
    /// @param to account for which we deposit
    /// @param tokenIndex which of the 2 governance tokens we are withdrawing
    function withdraw(
        uint256 amount,
        address to,
        uint8 tokenIndex
    ) external payable override {
        govTokens[tokenIndex].safeTransfer(to, amount);

        receiptTokens[tokenIndex].burn(to, amount);

        _afterWithdraw(amount, to, tokenIndex);
    }
}
