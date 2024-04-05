// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Voting.sol"; // Assurez-vous que le chemin vers Voting.sol est correct

contract VotingTest is Test {
    Voting private voting;
    address private owner;
    string[] private nfcIDs;

    function setUp() public {
        owner = address(this); // Simuler que le déploieur est aussi le propriétaire
        voting = new Voting("Test Vote");
        nfcIDs.push("NFC123");
    }

    function testAddOption() public {
        voting.addOption("Option 1");
        (string[] memory names, ) = voting.getOptions();
        assertEq(names[0], "Option 1");
    }

    function testAddDuplicateOption() public {
        voting.addOption("Option 1");
        vm.expectRevert("Option already exists");
        voting.addOption("Option 1"); // Ceci devrait échouer
    }

    function testVote() public {
        voting.addToWhitelist(nfcIDs);
        voting.addOption("Option 1");
        voting.castVote("Option 1", nfcIDs[0]);

        (, uint[] memory voteCounts) = voting.getOptions();
        assertEq(voteCounts[0], 1);
    }

    function testVoteNonWhitelistedNFC() public {
        voting.addOption("Option 1");
        vm.expectRevert("NFC ID not whitelisted");
        voting.castVote("Option 1", "NFC1234"); // Ceci devrait échouer
    }

    function testVoteOnPausedContract() public {
        voting.pause();
        vm.expectRevert("Pausable: paused");
        voting.addOption("Option 1"); // Ceci devrait échouer
    }

    function testPauseUnpause() public {
        voting.pause();
        assertTrue(voting.paused());

        voting.unpause();
        assertFalse(voting.paused());
    }

    function testCloseVotePermanently() public {
        voting.closeVotePermanently();
        assertTrue(voting.votingClosedPermanently());
    }

    function testAfterPermanentClosure() public {
        voting.closeVotePermanently();
        vm.expectRevert("Voting has been closed permanently");
        voting.addOption("Option 1"); // Ceci devrait échouer
    }
}