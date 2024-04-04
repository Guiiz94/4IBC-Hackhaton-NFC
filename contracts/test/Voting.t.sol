// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Voting.sol";

contract VotingTest is Test {
    Voting voting;

    function setUp() public {
        // Deployez le contrat Voting avec un nom de vote de test
        voting = new Voting("Test Vote");
    }

    function testAddAndVoteOption() public {
        // Testez l'ajout d'une option
        string memory optionName = "Option 1";
        voting.addOption(optionName);

        // Puisque nous ne pouvons pas acceder directement à `optionIndex`, nous pouvons verifier
        // le nombre d'options pour confirmer qu'une a ete ajoutee.
        (string[] memory names, ) = voting.getOptions();
        assertEq(names.length, 1, "Il devrait y avoir 1 option.");
        assertEq(names[0], optionName, "Le nom de l'option ajoutee devrait correspondre.");

        // Testez le vote pour l'option ajoutee
        voting.castVote(optionName);

        // Verifiez le nombre de votes pour l'option
        (, uint[] memory voteCounts) = voting.getOptions();
        assertEq(voteCounts[0], 1, "Le nombre de votes pour l'option 1 devrait etre 1.");
    }

    function testPauseAndUnpause() public {
        // Testez la mise en pause
        voting.pause();
        assertTrue(voting.paused(), "Le contrat devrait etre en pause.");

        // Testez la reprise
        voting.unpause();
        assertFalse(voting.paused(), "Le contrat ne devrait pas etre en pause.");
    }

    function testCloseVotePermanently() public {
        // Testez la fermeture permanente du vote
        voting.closeVotePermanently();
        assertTrue(voting.votingClosedPermanently(), "Le vote devrait etre ferme de maniere permanente.");
        
        // Verifiez que le contrat est en pause et ne peut pas etre repris
        assertTrue(voting.paused(), "Le contrat devrait etre en pause.");
        vm.expectRevert("Voting cannot be reopened after being closed permanently");
        voting.unpause();
    }

    function testAddOptionFailure() public {
        string memory optionName = "Option 1";
        voting.addOption(optionName);
        
        // Essayer d'ajouter la meme option une deuxieme fois doit echouer
        vm.expectRevert("Option already exists");
        voting.addOption(optionName);
    }

    function testVoteForNonexistentOption() public {
        string memory optionName = "Nonexistent Option";
        
        // Voter pour une option qui n'existe pas doit echouer
        vm.expectRevert("Option does not exist");
        voting.castVote(optionName);
    }

    function testVoteWhilePaused() public {
        string memory optionName = "Option 1";
        voting.addOption(optionName);
        voting.pause();
        
        // Voter alors que le contrat est en pause doit echouer
        vm.expectRevert("Pausable: paused");
        voting.castVote(optionName);
    }

    function testAddOptionWhenVotingClosedPermanently() public {
        string memory optionName = "Option 1";
        voting.closeVotePermanently();
        
        // Essayer d'ajouter une option apres la fermeture definitive doit echouer
        vm.expectRevert("Voting has been closed permanently");
        voting.addOption(optionName);
    }

    function testVoteWhenVotingClosedPermanently() public {
        string memory optionName = "Option 1";
        voting.addOption(optionName);
        voting.closeVotePermanently();
        
        // Voter apres la fermeture definitive doit echouer
        vm.expectRevert("Voting has been closed permanently");
        voting.castVote(optionName);
    }

    function testUnpauseAfterPermanentlyClosed() public {
        voting.closeVotePermanently();
        
        // Essayer de reprendre le vote apres une fermeture definitive doit echouer
        vm.expectRevert("Voting cannot be reopened after being closed permanently");
        voting.unpause();
    }
}
