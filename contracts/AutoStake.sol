// SPDX-License-Identifier: NO LICENSE
pragma solidity 0.7.6;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./ProxyCoin.sol";

contract AutoStake {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    struct UserData {
        address user;
        uint256 depositTime;
        uint256 share;
    }

    ProxyCoin public prxy;
    IERC20 public lpToken;
    uint256 public totalShares;
    uint256 public totalStakeUsers;
    uint256 public constant percentageDivider = 100;

    //user informations
    mapping(uint256 => address) public userList;
    mapping(address => UserData) public userInfo;
    mapping(address => bool) public smartContractStakers;

    event Staked(
        address indexed _user,
        uint256 _amountStaked,
        uint256 _balanceOf
    );

    constructor(address _prxy) {
        prxy = ProxyCoin(_prxy);
        lpToken = IERC20(_prxy);
    }

    // stake the coins
    function stake(uint256 amount) public {
        _stake(amount, tx.origin);
    }

    function _stake(uint256 _amount, address _who) internal {
        if (!smartContractStakers[_who]) {
            userList[totalStakeUsers] = _who;
            totalStakeUsers++;
            smartContractStakers[_who] = true;
            userInfo[_who].user = _who;
            userInfo[_who].depositTime = block.timestamp;
        }

        userInfo[_who].share = userInfo[_who].share.add(_amount);
        //update total shares in the end
        totalShares = totalShares.add(_amount);

        //if-> user is directly staking
        if (msg.sender == tx.origin) {
            // now we can issue shares
            lpToken.safeTransferFrom(_who, address(this), _amount);
        }
        /*through liquity contract */
        else {
            // now we can issue shares
            //transfer from liquidty contract
            lpToken.safeTransferFrom(msg.sender, address(this), _amount);
        }
        emit Staked(_who, _amount, claimedBalanceOf(_who));
    }

    /*
     *   ------------------Getter inteface for user---------------------
     *
     */

    function claimedBalanceOf(address _who) public view returns (uint256) {
        return getUserShare(_who);
    }

    function getUserShare(address _who) public view returns (uint256) {
        return userInfo[_who].share;
    }

    function getUserLastDepositTime(address _who) public view returns (uint256) {
        return userInfo[_who].depositTime;
    }

    /*
     *   ------------------Getter inteface for contract---------------------
     *
     */
}
