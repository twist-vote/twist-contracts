pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../Vault.sol";

import "./interfaces/IAaveGovernanceV2.sol";
import "./interfaces/IDelegationAwareToken.sol";
import "./interfaces/IStakedAave.sol";

contract AaveVault is Vault {
    using SafeERC20 for IERC20;
    address public voteContract;

    IStakedAave public immutable stkAaveToken;

    constructor(IERC20[2] memory govTokens_, IGauge gauge_) Vault(govTokens_, gauge_) {
        stkAaveToken = IStakedAave(address(govTokens[1]));
        // increase gauge allowance one and for all
        govTokens[1].safeIncreaseAllowance(
            address(gauge_),
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        );
    }

    function _afterDeposit(
        uint256 amount,
        address to,
        uint8 tokenIndex
    ) internal override {
        require(voteContract != address(0), "NO_VOTE_CONTRACT");
        // delegate token voting power after deposit
        IDelegationAwareToken(address(govTokens[tokenIndex])).delegateAll(voteContract);
    }

    /// @notice keep upgrade potential on the voting mecanism, admin only
    function setVoteContract(address voteContract_) external onlyOwner {
        voteContract = voteContract_;
    }

    /// @notice claimRewards claim all rewards from this vault, bribe, staking and bid rewards
    function claimRewards(
        uint256 amount,
        address to,
        uint8 tokenIndex
    ) external {
        if (tokenIndex == 0) {
            gauge.claimRewards(address(govTokens[tokenIndex]), to);
        }
        // token at index 1 is the one for additional rewards
        if (tokenIndex == 1) {
            uint256 pendingRewards = stkAaveToken.getTotalRewardsBalance(address(this));
            stkAaveToken.claimRewards(address(this), pendingRewards);
            // send the amount to the dividend contract on L2
            gauge.accrueAdditionalRewards(address(govTokens[tokenIndex]), amount);
            gauge.claimRewards(address(govTokens[tokenIndex]), to);
        }
    }
}
