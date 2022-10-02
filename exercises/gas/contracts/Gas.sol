// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract GasContract {
    uint256 public immutable totalSupply; // cannot be updated
    address[5] public administrators;

    struct Payment {
        uint256 paymentType;
        uint256 paymentID;
        uint256 amount;
    }
    struct ImportantStruct {
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
    }

    event Transfer(address, uint256);

    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;
    mapping(address => uint256) public whitelist;

    constructor (address[5] memory _admins, uint256 _totalSupply) payable{
        administrators = _admins;
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) external {
        unchecked {
            balances[_recipient] += _amount;
        }
        emit Transfer(_recipient, _amount);
        payments[msg.sender].push(Payment(1, 0, _amount));
    }

    function balanceOf(address _user) external view returns (uint256) {
        return balances[_user];
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        uint256 _type
    ) external {
        unchecked {
            for (uint256 i; i < 5; ++i) {
                if (administrators[i] == msg.sender) {
                    payments[_user][0].paymentType = _type;
                    payments[_user][0].amount = _amount;
                    return;
                }
            }
            revert();
        }
    }

    function getPayments(address _user)
        external
        view
        returns (Payment[] memory)
    {
        return payments[_user];
    }

    function getTradingMode() external pure returns (bool) {
        return true;
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) external {
        whitelist[_userAddrs] = _tier;
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct calldata _struct
    ) external {
        unchecked {
            _amount -= whitelist[msg.sender];
            balances[msg.sender] -= _amount;
            balances[_recipient] += _amount;
        }
    }
}
