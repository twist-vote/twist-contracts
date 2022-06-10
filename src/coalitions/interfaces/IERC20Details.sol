// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

interface IERC20Details {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}
