// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./CloneFactory.sol";
import "./Bucket.sol";

contract BucketFactory is Ownable, CloneFactory {
  mapping(string => Bucket) buckets;

  address receiverAddress;
  address libraryAddress;

  event BucketCreated(
    string id,
    address bucket
  );

  constructor() {
    receiverAddress = msg.sender;
  }

  function createBucket(string memory id)
    external
    onlyOwner
  {
    require(
      address(buckets[id]) == address(0x0),
      "Bucket already exists"
    );

    address clone = createClone(libraryAddress);
    Bucket bucket = Bucket(payable(clone));

    bucket.init(id, payable(receiverAddress));

    buckets[id] = bucket;

    emit BucketCreated(
      id,
      address(bucket)
    );
  }

  function getBucketAddress(string memory id)
    external
    view
    returns (address)
  {
    require(
      address(buckets[id]) != address(0x0),
      "Bucket does not exist. Please create one first."
    );

    return address(buckets[id]);
  }

  function setReceiverAddress(address _receiverAddress)
    external
    onlyOwner
  {
    receiverAddress = payable(_receiverAddress);
  }

  function getReceiverAddress() external view returns(address) {
    return receiverAddress;
  }

  function setLibraryAddress(address _libraryAddress)
    external
    onlyOwner
  {
    libraryAddress = _libraryAddress;
  }
}
