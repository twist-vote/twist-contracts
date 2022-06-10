//SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./interfaces/ISpacePot.sol";

////////////////////////////////////////////////////////////////////////////////////////////
///
/// @title Twist Pot
/// @author contact@twist.vote
/// @notice
///
////////////////////////////////////////////////////////////////////////////////////////////
contract SpacePot is Initializable, OwnableUpgradeable, ISpacePot {
    using SafeERC20 for IERC20;

    /// @dev address of the bid asset
    address public bidAsset;

    /// @dev name of the bribe pool
    string public name;

    /// @dev proposalId => optionId => incentive: nested mapping of bribe pots created per proposal
    mapping(bytes32 => mapping(uint256 => Incentive)) public incentives;

    /// @dev proposalId => optionId => user => deposit amount: nested mapping of deposits for every bribe incentive
    mapping(bytes32 => mapping(uint256 => mapping(address => uint256))) public depositors;

    /// @dev proposalId => optionId => user => claimed: nested map of rewards claimed
    mapping(bytes32 => mapping(uint256 => mapping(address => bool))) public claimedReward;

    /// @dev initialize the bribe pool
    /// @param _name name of the bribe pool
    /// @param _admin admin/owner of the bribe pool
    /// @param _bidAsset address of the bribe token
    function initialize(
        string calldata _name,
        address _admin,
        address _bidAsset
    ) external override initializer {
        __Ownable_init();
        _transferOwnership(_admin);

        name = _name;
        bidAsset = _bidAsset;
    }

    /// @dev get the current state of the incentive
    /// @param proposalId ID of the proposal
    /// @param optionIndex index/number of the bribe incentive for that proposal
    function getPotState(bytes32 proposalId, uint256 optionIndex)
        public
        view
        returns (IncentiveState)
    {
        Incentive memory incentive = incentives[proposalId][optionIndex];

        if (incentive.totalDeposits == 0) {
            return IncentiveState.NOT_CREATED;
        } else if (incentive.executedAt == 0) {
            return IncentiveState.ACTIVE;
        } else if (block.timestamp < incentive.executedAt + 3 days) {
            return IncentiveState.EXECUTED;
        } else {
            return IncentiveState.EXPIRED;
        }
    }

    /// @dev Deposit bribe against a bribe incentive
    /// @param proposalId ID of the proposal
    /// @param optionIndex index/number of the bribe incentive for that proposal
    /// @param to address to credit the bidasset deposit
    /// @param amount amount to deposit
    function deposit(
        bytes32 proposalId,
        uint256 optionIndex,
        address to,
        uint128 amount
    ) external override {
        IncentiveState incentiveState = getPotState(proposalId, optionIndex);

        require(
            incentiveState == IncentiveState.ACTIVE || incentiveState == IncentiveState.NOT_CREATED,
            "ONLY_WHEN_ACTIVE_OR_NOT_CREATED"
        );
        require(amount > 0, "ZERO_AMOUNT");

        Incentive storage incentive = incentives[proposalId][optionIndex];

        /// interactions
        IERC20(bidAsset).safeTransferFrom(msg.sender, address(this), amount);

        /// effects
        unchecked {
            depositors[proposalId][optionIndex][to] += amount;
            incentive.totalDeposits += amount;
        }

        emit DepositedIncentive(proposalId, optionIndex, to, amount);
    }

    /// @dev submit the merkle reward and total votes for relevant incentive.
    /// @param proposalId ID of the proposal
    /// @param optionIndex index/number of the bribe incentive for that proposal
    /// @param _merkleRoot merkle root of the reward tree
    /// @param _totalVotes total votes that have been voted for the bribe incentive
    function submitMerkleRoot(
        bytes32 proposalId,
        uint256 optionIndex,
        bytes32 _merkleRoot,
        bytes32 _ipfsHash,
        uint128 _totalVotes
    ) external onlyOwner {
        require(getPotState(proposalId, optionIndex) == IncentiveState.ACTIVE, "POT_NOT_ACTIVE");
        require(_totalVotes != 0, "ZERO_TOTAL_VOTES");
        require(_merkleRoot != bytes32(0), "INVALID_MERKLE_ROOT");

        Incentive storage incentive = incentives[proposalId][optionIndex];

        incentive.totalVotes = _totalVotes;
        incentive.merkleRoot = _merkleRoot;
        incentive.ipfsHash = _ipfsHash;
        incentive.executedAt = block.timestamp;

        emit SubmittedMerkleRoot(proposalId, optionIndex, _merkleRoot, _totalVotes);
    }

    function leftoversToWithdraw(
        bytes32 proposalId,
        uint256 optionIndex,
        address to
    ) public view returns (Leftovers memory leftovers) {
        Incentive memory incentive = incentives[proposalId][optionIndex];
        uint256 userDeposit = depositors[proposalId][optionIndex][to];
        leftovers.amount = userDeposit;

        IncentiveState incentiveState = getPotState(proposalId, optionIndex);
        if (incentiveState == IncentiveState.EXPIRED) {
            leftovers.amount =
                (userDeposit / incentive.totalDeposits) *
                (incentive.totalDeposits - incentive.depositReclaimed);
            leftovers.claimable = true;
        } else {
            leftovers.amount =
                (userDeposit / incentive.totalDeposits) *
                (incentive.totalDeposits - incentive.depositReclaimed);
            leftovers.claimable = false;
        }
    }

    /// @dev withdraw the bribe incentive
    /// @param proposalId ID of the proposal
    /// @param optionIndex index/number of the bribe incentive for that proposal
    /// @param to address to withdraw for
    function withdrawLeftovers(
        bytes32 proposalId,
        uint256 optionIndex,
        address to
    ) external {
        Incentive storage incentive = incentives[proposalId][optionIndex];
        Leftovers memory leftovers = leftoversToWithdraw(proposalId, optionIndex, to);

        require(leftovers.claimable, "PROPOSAL_NOT_EXECUTED");

        incentive.depositReclaimed += leftovers.amount;
        depositors[proposalId][optionIndex][to] = 0;

        // interactions
        IERC20(bidAsset).safeTransfer(to, leftovers.amount);

        emit WithdrewDeposit(proposalId, optionIndex, msg.sender, to, leftovers.amount);
    }

    function rewardsToClaim(
        bytes32 proposalId,
        uint256 optionIndex,
        bytes32[] calldata proof,
        address to,
        uint256 vp
    ) external view returns (uint256 rewards) {
        Incentive memory incentive = incentives[proposalId][optionIndex];
        // If a merkleroot is attached to the incentive, we can claim
        require(verify(proof, incentive.merkleRoot, to, vp), "INVALID_MERKLE_PROOF");
        require(!claimedReward[proposalId][optionIndex][to], "REWARD_ALREADY_CLAIMED");

        rewards = (vp * incentive.totalDeposits) / incentive.totalVotes;
        uint256 leftovers = incentive.totalDeposits - incentive.depositReclaimed;
        // after incentive expiration, depositors may withdraw leftovers, in that case the totalDeposits may not be complete
        rewards = rewards > leftovers ? leftovers : rewards;
    }

    /// @dev claim multiple rewards
    /// @param proposalId array of proposal id to claim reward from
    /// @param optionIndex  array of optionIndex
    /// @param proof proofs for all the rewards
    /// @param vp array voting power
    function claimRewards(
        bytes32[] calldata proposalId,
        uint256[] calldata optionIndex,
        bytes32[][] calldata proof,
        address[] calldata to,
        uint256[] calldata vp
    ) external override returns (uint256[] memory rewards) {
        require(proposalId.length == optionIndex.length, "ARITY_MISMATCH");
        require(optionIndex.length == proof.length, "ARITY_MISMATCH");
        require(optionIndex.length == vp.length, "ARITY_MISMATCH");

        rewards = new uint256[](optionIndex.length);
        for (uint256 index = 0; index < proposalId.length; index++) {
            rewards[index] = _claimRewards(
                proposalId[index],
                optionIndex[index],
                proof[index],
                vp[index],
                to[index]
            );
        }
    }

    /// @dev claim the rewards
    /// @param proposalId ID of the proposal
    /// @param optionIndex index/number of the bribe incentive
    /// @param proof merkle proof
    /// @param vp voting power of the tree that contains the reward
    /// @param to address to claim for
    function _claimRewards(
        bytes32 proposalId,
        uint256 optionIndex,
        bytes32[] calldata proof,
        uint256 vp,
        address to
    ) internal returns (uint256) {
        Incentive storage incentive = incentives[proposalId][optionIndex];
        // If a merkleroot is attached to the incentive, we can claim
        require(verify(proof, incentive.merkleRoot, to, vp), "INVALID_MERKLE_PROOF");
        require(!claimedReward[proposalId][optionIndex][to], "REWARD_ALREADY_CLAIMED");

        uint256 reward = (vp * incentive.totalDeposits) / incentive.totalVotes;
        uint256 leftovers = incentive.totalDeposits - incentive.depositReclaimed;
        // after incentive expiration, depositors may withdraw leftovers, in that case the totalDeposits may not be complete
        reward = reward > leftovers ? leftovers : reward;

        // effects
        incentive.depositReclaimed += reward;
        claimedReward[proposalId][optionIndex][to] = true;

        // interactions
        IERC20(bidAsset).safeTransfer(to, reward);

        emit ClaimedReward(proposalId, optionIndex, to, reward);

        return reward;
    }

    /// @dev verify the merkle root
    /// @param proof Merkle proof
    /// @param root Merkle Root\
    /// @param to address we claim for
    /// @param vp voting power
    function verify(
        bytes32[] calldata proof,
        bytes32 root,
        address to,
        uint256 vp
    ) public pure returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(to, vp));
        return MerkleProof.verify(proof, root, leaf);
    }
}
