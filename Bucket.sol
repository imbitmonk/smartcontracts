// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Bucket {
  string public id;
  address payable receiver;

  event Received(
    string id,
    uint value,
    address sender
  );

  function init(string memory _id, address payable _receiver) public {
    id = _id;
    receiver = payable(_receiver);
  }

  receive() external payable {
    emit Received(id, msg.value, msg.sender);
    receiver.transfer(msg.value);
  }

  function transfer(address erc20Address) external {
    IERC20 erc20 = IERC20(erc20Address);
    uint256 balance = erc20.balanceOf(address(this));
    erc20.transfer(receiver, balance);
  }
}
