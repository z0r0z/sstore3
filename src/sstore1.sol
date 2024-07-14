// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

contract sstore1 {
    uint256 public data;

    function store(uint256 _data) public payable {
        data = _data;
    }
}
