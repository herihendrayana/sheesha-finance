// SPDX-License-Identifier: NO LICENSE
pragma solidity 0.7.6;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Sheesha is ERC20Burnable {
    using SafeMath for uint256;
    //1 million
    uint256 public constant initialSupply = 1000000e18;
    uint256 public contractStartTimestamp;

    //   15% team (4% monthly unlock over 25 months)
    // 10% dev
    // 10% marketing
    // 15% liquidity provision
    // 10% SHE staking rewards
    // 20% LP rewards
    // 20% Reserve

    constructor() ERC20("Sheesha Finance", "SHE") {
        _mint(address(this), initialSupply);
        contractStartTimestamp = block.timestamp;
    }
}
