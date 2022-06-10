// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MockERC20.sol";

contract MockStkAave is MockERC20 {
    function delegateAll(address delegatee) external {}
}
