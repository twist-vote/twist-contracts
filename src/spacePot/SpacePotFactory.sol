//SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Multicall.sol";

import "./interfaces/ISpacePot.sol";

////////////////////////////////////////////////////////////////////////////////////////////
///
/// @title Bribe Pool Factory
/// @author contact@bribe.xyz
/// @notice
///
////////////////////////////////////////////////////////////////////////////////////////////

contract SpacePotFactory is Ownable, Multicall {
    using SafeERC20 for IERC20;

    /// @dev implementation address of the bribe pool contract
    address public spacePotImplementation;

    address public bidAsset;

    /// @dev mapping of bribe pools to it's addresses
    mapping(string => address) public spacePots;

    event CreatedNewSpacePot(address indexed spacePot, string indexed protocolName);

    /// @dev initialize the bribe pool factory. can be called only once
    /// @param _admin contract admin
    /// @param _spacePotImplementation implementation address of the bribe pool contract
    constructor(
        address _admin,
        address _bidAsset,
        address _spacePotImplementation
    ) Ownable() {
        require(_spacePotImplementation != address(0), "ZERO_ADDRESS");

        super.transferOwnership(_admin);
        bidAsset = _bidAsset;
        spacePotImplementation = _spacePotImplementation;
    }

    /// @notice changing the default bid asset for all further Pot implementation
    /// @param _bidAsset the new bid asset
    function changeBidAsset(address _bidAsset) external onlyOwner {
        bidAsset = _bidAsset;
    }

    /// @notice create a deposit to an unexisting space, will create the space and deposit the first amount on a proposal
    /// @param _protocolName the space we want to create incentive for
    /// @param proposalId the proposal ID
    /// @param optionIndex choice to incentivise
    /// @param to who to deposit for
    /// @param amount amount to deposit
    function createSpacePotAndDeposit(
        string calldata _protocolName,
        bytes32 proposalId,
        uint256 optionIndex,
        address to,
        uint128 amount
    ) external returns (address potAddress) {
        require(spacePots[_protocolName] == address(0), "POOL_ALREADY_EXISTS");
        potAddress = ClonesUpgradeable.clone(spacePotImplementation);
        ISpacePot(potAddress).initialize(_protocolName, owner(), bidAsset);
        spacePots[_protocolName] = potAddress;
        IERC20(bidAsset).safeTransferFrom(msg.sender, address(this), amount);
        IERC20(bidAsset).safeIncreaseAllowance(potAddress, amount);
        ISpacePot(potAddress).deposit(proposalId, optionIndex, to, amount);
        emit CreatedNewSpacePot(potAddress, _protocolName);
    }

    /// @dev claim all rewards from a space
    /// @param proposalId array of proposal id to claim reward from
    /// @param optionIndex  array of optionIndex
    /// @param proof proofs for all the rewards
    /// @param vp array voting power
    function claimAllFrom(
        string calldata _protocolName,
        bytes32[] calldata proposalId,
        uint256[] calldata optionIndex,
        bytes32[][] calldata proof,
        address[] calldata to,
        uint256[] calldata vp
    ) public returns (uint256[] memory rewards) {
        require(spacePots[_protocolName] != address(0), "Unexisting space");
        rewards = ISpacePot(spacePots[_protocolName]).claimRewards(
            proposalId,
            optionIndex,
            proof,
            to,
            vp
        );
    }
}
