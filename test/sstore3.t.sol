// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {sstore3} from "../src/sstore3.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract sstore3Test is Test {
    sstore3 internal test;

    function setUp() public payable {
        test = new sstore3();
    }

    function testStore() public payable {
        test.store{value: 123456789}();
    }

    function testRead() public payable {
        test.store{value: 123456789}();
        assertEq(test.data(), 123456789);
    }
}
