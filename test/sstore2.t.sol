// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {sstore2} from "../src/sstore2.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract sstore2Test is Test {
    sstore2 internal test;

    function setUp() public payable {
        test = new sstore2();
    }

    function testStore() public payable {
        test.store(123456789);
    }

    function testRead() public payable {
        test.store(123456789);
        assertEq(test.data(), 123456789);
    }
}
