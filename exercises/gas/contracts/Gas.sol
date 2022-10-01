// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract GasContract {
    uint16 public immutable totalSupply; // cannot be updated
    address[5] public administrators;

    struct Payment {
        uint8 paymentType;
        uint8 paymentID;
        uint16 amount;
    }
    struct ImportantStruct {
        uint8 valueA; // max 3 digits
        uint64 bigValue;
        uint8 valueB; // max 3 digits
    }

    event Transfer(address recipient, uint16 amount);

    mapping(address => uint16) balances;
    mapping(address => Payment[]) payments;
    mapping(address => uint8) public whitelist;

    constructor(address[5] memory _admins, uint16 _totalSupply) {
        totalSupply = _totalSupply;
        administrators = _admins;
        balances[msg.sender] = totalSupply;
    }

    function transfer(
        address _recipient,
        uint16 _amount,
        string calldata _name
    ) external { unchecked{
        balances[_recipient] += _amount;}
        emit Transfer(_recipient, _amount);
        payments[msg.sender].push(Payment(1, 0, _amount));
    }

    function balanceOf(address _user) external view returns (uint16) {
        return balances[_user];
    }

    function updatePayment(
        address _user,
        uint8 _ID,
        uint16 _amount,
        uint8 _type
    ) external {
        unchecked{
        for (uint8 i = 0; i < 6; ++i) {
            if (administrators[i] == msg.sender) {
                payments[_user][0].paymentType = _type;
                payments[_user][0].amount = _amount;
                return;
            }
        }
        revert();
    }}

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

    function addToWhitelist(address _userAddrs, uint8 _tier) external {
        whitelist[_userAddrs] = _tier;
    }

    function whiteTransfer(
        address _recipient,
        uint16 _amount,
        ImportantStruct calldata _struct
    ) external { unchecked {
        uint16 temp = _amount- whitelist[msg.sender];
        balances[msg.sender] -= temp;
        balances[_recipient] += temp;
    }}
}
