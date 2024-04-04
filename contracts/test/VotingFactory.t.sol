// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VotingFactory.sol";
import "../src/Voting.sol";

contract VotingFactoryTest is Test {
    VotingFactory votingFactory;

    function setUp() public {
        votingFactory = new VotingFactory();
    }

    function testCreateVoting() public {
        string memory voteName = "Test Vote";
        address testOwner = address(0x123); // Utilisez une adresse test arbitraire pour l'owner
        
        // Attendre l'événement VotingCreated pour vérifier que le contrat est bien créé
        vm.expectEmit(true, true, true, true);
        // Ajustez l'ordre des paramètres de l'événement selon votre contrat VotingFactory
        emit VotingCreated(address(0), block.chainid, voteName, testOwner); // Placeholder pour l'adresse du contrat Voting

        votingFactory.createVoting(voteName, testOwner);
    }

    // Event placeholder, assurez-vous que l'ordre des paramètres correspond à celui émis par votre contrat
    event VotingCreated(address indexed votingAddress, uint chainId, string voteName, address indexed owner);
}
