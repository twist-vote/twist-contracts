//SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

interface ISpacePot {
    /// @dev Incentive state
    enum IncentiveState {
        NOT_CREATED, // no deposit yet
        ACTIVE, // incentive is not expired nor executed
        EXECUTED, // incentive option is executed and recipient can claim rewards
        EXPIRED // both incentivisers and voters can grab leftovers or claim rewards
    }

    /// @param totalVotes total votes accumulated by the incentive
    /// @param totalDeposits total bribe put in the incentive
    /// @param executedAt executed time
    /// @param depositReclaimed after 90 days of airdrop, depositors can potentially reclaim their incentive
    /// @param merkleRoot merkle root
    /// @param ipfsHash ipfs hash where the json rewards is stored
    struct Incentive {
        uint256 totalVotes;
        uint256 totalDeposits;
        uint256 executedAt;
        uint256 depositReclaimed;
        bytes32 merkleRoot;
        bytes32 ipfsHash;
    }

    /// @param claimable is the leftovers already claimable
    /// @param amount amount to withdraw at time t
    struct Leftovers {
        bool claimable;
        uint256 amount;
    }

    /***************** events ****************/

    event CancelledIncentive(address user, bytes32 indexed proposalId, uint256 optionIndex);
    event DepositedIncentive(
        bytes32 indexed proposalId,
        uint256 optionIndex,
        address indexed to,
        uint256 amount
    );
    event SubmittedMerkleRoot(
        bytes32 proposalId,
        uint256 optionIndex,
        bytes32 indexed _merkleRoot,
        uint256 _totalVotes
    );
    event WithdrewDeposit(
        bytes32 indexed proposalId,
        uint256 optionIndex,
        address indexed depositor,
        address receiver,
        uint256 amountToReceive
    );
    event ClaimedReward(
        bytes32 indexed proposalId,
        uint256 optionIndex,
        address indexed recipient,
        uint256 reward
    );

    /***************** functions ****************/

    /// @dev initialize the bribe pool
    /// @param _name name of the bribe pool
    function initialize(
        string calldata _name,
        address _admin,
        address _bidAsset
    ) external;

    /// @dev Deposit bribe against a bribe incentive
    /// @param proposalId ID of the proposal
    /// @param optionIndex index/number of the bribe incentive for that proposal
    /// @param _to address to credit the bidasset deposit
    /// @param _amount amount to deposit
    function deposit(
        bytes32 proposalId,
        uint256 optionIndex,
        address _to,
        uint128 _amount
    ) external;

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
    ) external returns (uint256[] memory rewards);
}
