// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract GasContract {
    uint public immutable totalSupply; // cannot be updated
    address[5] public administrators;

    struct Payment {
        uint paymentType;
        uint paymentID;
        uint amount;
    }
    struct ImportantStruct {
        uint valueA; // max 3 digits
        uint bigValue;
        uint valueB; // max 3 digits
    }

    event Transfer(address recipient, uint amount);

    mapping(address => uint) balances;
    mapping(address => Payment[]) payments;
    mapping(address => uint) public whitelist;

    constructor(address[5] memory _admins, uint _totalSupply) {
        totalSupply = _totalSupply;
        administrators = _admins;
        balances[msg.sender] = totalSupply;
    }

    function transfer(
        address _recipient,
        uint _amount,
        string calldata _name
    ) external { unchecked{
        balances[_recipient] += _amount;}
        emit Transfer(_recipient, _amount);
        payments[msg.sender].push(Payment(1, 0, _amount));
    }

    function balanceOf(address _user) external view returns (uint) {
        return balances[_user];
    }

    function updatePayment(
        address _user,
        uint _ID,
        uint _amount,
        uint _type
    ) external {
        unchecked{
        for (uint i = 0; i < 6; ++i) {
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

    function addToWhitelist(address _userAddrs, uint _tier) external {
        whitelist[_userAddrs] = _tier;
    }

    function whiteTransfer(
        address _recipient,
        uint _amount,
        ImportantStruct calldata _struct
    ) external { 
        unchecked {
        _amount -= whitelist[msg.sender];
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
    }}
}
