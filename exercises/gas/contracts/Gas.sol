// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract GasContract {
    uint16 public totalSupply; // cannot be updated
    uint8 paymentCounter;
    uint8 constant tradePercent = 12;
    address Owner;
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
        Owner = msg.sender;
        administrators = _admins;
        balances[Owner] = totalSupply;
    }

    function transfer(
        address _recipient,
        uint16 _amount,
        string calldata _name
    ) external {
        balances[_recipient] += _amount;
        balances[msg.sender] -= _amount;
        emit Transfer(_recipient, _amount);
        Payment memory payment;
        payment.amount = _amount;
        payment.paymentType = 1;
        payment.paymentID = ++paymentCounter;
        payments[msg.sender].push(payment);
    }

    function updatePayment(
        address _user,
        uint8 _ID,
        uint16 _amount,
        uint8 _type
    ) external {
        require(checkForAdmin(msg.sender));
                payments[_user][0].paymentType = _type;
                payments[_user][0].amount = _amount;
    }

    function addToWhitelist(address _userAddrs, uint8 _tier) external {
        whitelist[_userAddrs] = _tier;
    }

    function whiteTransfer(
        address _recipient,
        uint16 _amount,
        ImportantStruct calldata _struct
    ) external {
        balances[msg.sender] -= _amount - whitelist[msg.sender];
        balances[_recipient] += _amount - whitelist[msg.sender];
    }

    function checkForAdmin(address _user) internal view returns (bool admin) {
        for (uint8 ii = 0; ii < 5; ii++) {
            if (administrators[ii] == _user) {
                admin = true;
            }
        }
    }

    function balanceOf(address _user) external view returns (uint16) {
        return balances[_user];
    }

    function getTradingMode() external pure returns (bool) {
        return true;
    }

    function getPayments(address _user)
        external
        view
        returns (Payment[] memory)
    {
        return payments[_user];
    }
}