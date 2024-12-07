// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

contract sstore4 {
    function store() public payable {}

    function data() public view returns (uint256 bits) {
        assembly ("memory-safe") {
            bits := selfbalance()
        }
    }
}
