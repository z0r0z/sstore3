// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {sstore1} from "../src/sstore1.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract sstore1Test is Test {
    sstore1 internal test;

    function setUp() public payable {
        test = new sstore1();
    }

    function testStore() public payable {
        test.store(123456789);
    }

    function testRead() public payable {
        test.store(123456789);
        assertEq(test.data(), 123456789);
    }
}
