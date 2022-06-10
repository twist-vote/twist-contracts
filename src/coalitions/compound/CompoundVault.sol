pragma solidity ^0.8.4;

import "../Vault.sol";
import "./interfaces/IComp.sol";

contract CompoundVault is Vault {
    using SafeERC20 for IERC20;
    address public voteContract;

    IComp public immutable compToken;

    constructor(IERC20[2] memory govTokens_, IGauge gauge_) Vault(govTokens_, gauge_) {
        compToken = IComp(address(govTokens[0]));
    }

    function _afterDeposit(
        uint256 amount,
        address to,
        uint8 tokenIndex
    ) internal override {
        require(voteContract != address(0), "NO_VOTE_CONTRACT");
        if (tokenIndex == 0) {
            IComp(address(govTokens[tokenIndex])).delegate(voteContract);
        }
    }

    function setVoteContract(address voteContract_) external onlyOwner {
        voteContract = voteContract_;
    }
}
