//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.4;

interface IReceiptToken {
    function mint(address, uint256) external;

    function burn(address, uint256) external;
}
