// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.12;

import "ds-test/test.sol";

import "./CureReporter.sol";

contract CureReporterTest is DSTest {
    CureReporter reporter;

    function setUp() public {
        reporter = new CureReporter();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
