
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Voting.sol";

contract VotingTest is Test {
    Voting voting;
    address public owner;
    address public nonOwner;

    function setUp() public {
        owner = address(0x1);
        nonOwner = address(0x2);
        voting = new Voting("TestVote", owner);
    }

    function testAddOptionSuccess() public {
        vm.prank(owner);
        voting.addOption("Option 1");
        (string[] memory names, uint[] memory voteCounts) = voting.getOptions();
        assertEq(names[0], "Option 1");
        assertEq(voteCounts[0], 0);
    }

    function testAddOptionFailureNotOwner() public {
        vm.prank(nonOwner);
        vm.expectRevert();
        voting.addOption("Option 1");
    }


    function testCastVoteSuccess() public {
        vm.prank(owner);
        voting.addOption("Option 1");
        vm.prank(owner);
        voting.castVote("Option 1");
        (, uint[] memory voteCounts) = voting.getOptions();
        assertEq(voteCounts[0], 1);
    }

    function testCastVoteOptionDoesNotExist() public {
        vm.expectRevert("Option does not exist");
        vm.prank(owner);
        voting.castVote("Option Nonexistent");
    }

    function testGetOptions() public {
        vm.prank(owner);
        voting.addOption("Option 1");
        vm.prank(owner);
        voting.addOption("Option 2");
        vm.prank(owner);
        voting.castVote("Option 1");

        (string[] memory names, uint[] memory voteCounts) = voting.getOptions();
        assertEq(names.length, 2);
        assertEq(voteCounts.length, 2);
        assertEq(names[0], "Option 1");
        assertEq(voteCounts[0], 1);
        assertEq(names[1], "Option 2");
        assertEq(voteCounts[1], 0);
    }
}