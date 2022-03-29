pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Arrays.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import "./interfaces/IGaugeSnapshot.sol";

/// @title GaugeSnapshot
/// @notice Snapshot gauge, used to distribute bid rewards to vault staker.
/// Borrow snapshot logic from ERC20Snapshot to accurately distribute rewards based on a previous snapshot from stakers
abstract contract GaugeSnapshot is IGaugeSnapshot, Ownable {
    using SafeERC20 for IERC20;
    using Arrays for uint256[];
    using Arrays for address[];
    using Counters for Counters.Counter;

    // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
    // Snapshot struct, but that would impede usage of functions that work on an array.
    struct Snapshots {
        uint256[] ids;
        uint256[] values;
    }

    IERC20 immutable bidToken;

    address[] public tokens;

    mapping(address => address) receiptToToken;
    mapping(address => address) tokenToReceipt;
    // address[] receiptTokens;

    mapping(address => uint256) public userDebts;

    mapping(address => mapping(address => Snapshots)) private _accountBalanceSnapshots;
    mapping(address => Snapshots) private _totalSupplySnapshots;

    /// @dev
    mapping(address => mapping(uint256 => uint256)) private _rewardsCheckpoints;

    // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
    mapping(address => Counters.Counter) private _currentSnapshotId;

    constructor(IERC20 bidToken_) {
        bidToken = bidToken_;
    }

    /// @notice create a new snapshot, a new snapshot will be created at this point in time
    /// @param token for which to create the snapshot
    function _snapshot(address token) internal virtual returns (uint256) {
        Counters.Counter storage counter = _currentSnapshotId[token];

        counter.increment();

        uint256 currentId = _getCurrentSnapshotId(token);
        emit Snapshot(currentId);
        return currentId;
    }

    /**
     * @dev Get the current snapshotId
     */
    function _getCurrentSnapshotId(address token) internal view virtual returns (uint256) {
        return _currentSnapshotId[token].current();
    }

    // function add(address token) external onlyOwner {

    // }

    /**
     * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
     */
    function balanceOfAt(
        address token,
        address account,
        uint256 snapshotId
    ) public view virtual returns (uint256) {
        (bool snapshotted, uint256 value) = _valueAt(
            token,
            snapshotId,
            _accountBalanceSnapshots[token][account]
        );

        return snapshotted ? value : IERC20(tokenToReceipt[token]).balanceOf(account);
    }

    /**
     * @dev Retrieves the total supply at the time `snapshotId` was created.
     */
    function totalSupplyAt(address token, uint256 snapshotId)
        public
        view
        virtual
        returns (uint256)
    {
        (bool snapshotted, uint256 value) = _valueAt(
            token,
            snapshotId,
            _totalSupplySnapshots[token]
        );

        return snapshotted ? value : IERC20(tokenToReceipt[token]).totalSupply();
    }

    /// @notice called by the receipt token, create a checkpoint for each deposit, transfer, mint of the underlying receiptToken
    /// @param govToken governance token
    /// @param account account address for which we accumulate rewards
    function accumulateBidRewards(address govToken, address account) external override {
        // check sender address @todo only token present in the list are allowed
        _updateUserSnapshot(govToken, account, IERC20(govToken).balanceOf(account));
        _updateTotalSupplySnapshot(govToken, IERC20(govToken).totalSupply());
    }

    /// @notice accrue rewards for the bid token, unprotected external function, a hacker wishing to distribute more rewards is free to do so
    /// @param token governance token for which to accrue bid rewards
    /// @param amount rewards amount to accrue
    function accrueBidReward(address token, uint256 amount) external override {
        _snapshot(token);
        // consider this function to be called from L1
        bidToken.safeTransferFrom(msg.sender, address(this), amount);
        _rewardsCheckpoints[token][_getCurrentSnapshotId(token)] += amount;
    }

    /// @notice claim bid rewards for all the governance tokens
    /// @param to Address to claim rewards for
    function _claimRewards(address to) internal virtual {
        uint256 totalRewards = 0;
        for (uint256 i = 0; i < tokens.length; i++) {
            _updateUserSnapshot(tokens[i], msg.sender, IERC20(tokens[i]).balanceOf(msg.sender));
            _updateTotalSupplySnapshot(tokens[i], IERC20(tokens[i]).totalSupply());
            // get all snapshots for rewards
            Snapshots memory accountSnapshot = _accountBalanceSnapshots[tokens[i]][msg.sender];
            for (uint256 j = 0; j < accountSnapshot.ids.length; j++) {
                // avoid division by zero
                if (totalSupplyAt(tokens[i], accountSnapshot.ids[j]) > 0) {
                    totalRewards +=
                        _rewardsCheckpoints[tokens[i]][accountSnapshot.ids[j]] *
                        (balanceOfAt(tokens[i], msg.sender, accountSnapshot.ids[j]) /
                            totalSupplyAt(tokens[i], accountSnapshot.ids[j]));
                }
            }
        }
        if (totalRewards > userDebts[msg.sender]) {
            bidToken.safeTransfer(to, totalRewards - userDebts[msg.sender]);
            emit RewardsClaimed(totalRewards - userDebts[msg.sender], to);
            userDebts[msg.sender] = totalRewards;
        }
    }

    /// @notice get the current pending rewards for msg.sender
    function pendingRewards() public view returns (uint256 rewards) {
        uint256 totalRewards = 0;
        for (uint256 i = 0; i < tokens.length; i++) {
            // get all snapshots for rewards
            // Snapshots memory accountSnapshot = _accountBalanceSnapshots[tokens[i]][msg.sender];
            for (uint256 j = 1; j <= _getCurrentSnapshotId(tokens[i]); j++) {
                totalRewards +=
                    _rewardsCheckpoints[tokens[i]][j] *
                    (balanceOfAt(tokens[i], msg.sender, j) / totalSupplyAt(tokens[i], j));
            }
        }
        rewards = totalRewards - userDebts[msg.sender];
    }

    function _valueAt(
        address token,
        uint256 snapshotId,
        Snapshots storage snapshots
    ) private view returns (bool, uint256) {
        require(snapshotId > 0, "ERC20Snapshot: id is 0");
        require(snapshotId <= _getCurrentSnapshotId(token), "ERC20Snapshot: nonexistent id");

        // When a valid snapshot is queried, there are three possibilities:
        //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
        //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
        //  to this id is the current one.
        //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
        //  requested id, and its value is the one to return.
        //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
        //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
        //  larger than the requested one.
        //
        // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
        // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
        // exactly this.

        uint256 index = snapshots.ids.findUpperBound(snapshotId);

        if (index == snapshots.ids.length) {
            return (false, 0);
        } else {
            return (true, snapshots.values[index]);
        }
    }

    function _updateUserSnapshot(
        address token,
        address account,
        uint256 amount
    ) private {
        _updateSnapshot(token, _accountBalanceSnapshots[token][account], amount);
    }

    function _updateTotalSupplySnapshot(address token, uint256 totalSupply) private {
        _updateSnapshot(token, _totalSupplySnapshots[token], totalSupply);
    }

    function _updateSnapshot(
        address token,
        Snapshots storage snapshots,
        uint256 currentValue
    ) private {
        uint256 currentId = _getCurrentSnapshotId(token);
        if (_lastSnapshotId(snapshots.ids) < currentId) {
            snapshots.ids.push(currentId);
            snapshots.values.push(currentValue);
        }
    }

    function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
        if (ids.length == 0) {
            return 0;
        } else {
            return ids[ids.length - 1];
        }
    }
}
