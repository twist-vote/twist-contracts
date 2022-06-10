pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Twist is ERC20 {
    constructor(uint256 totalSupply_, address multisig) ERC20("Twist", "TWT") {
        _mint(multisig, totalSupply_);
    }
}
