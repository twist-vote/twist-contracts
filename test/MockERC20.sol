pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("MockERC20", "MCK") {}

    function setBalance(uint256 amount) external {
        // _balances[msg.sender] = amount;
        _mint(msg.sender, amount);
    }
}
