pragma solidity ^0.8.4;

interface IVault {
    event Deposit(uint256 amount, address to, uint8 tokenIndex);

    event Withdraw(uint256 amount, address to, uint8 tokenIndex);

    function deposit(
        uint256 amount,
        address to,
        uint8 tokenIndex
    ) external payable;

    function withdraw(
        uint256 amount,
        address to,
        uint8 tokenIndex
    ) external payable;
}
