// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Voting.sol";

contract VotingFactory {
    // Événement pour loguer l'adresse des nouveaux contrats Voting créés
    event VotingCreated(address indexed votingAddress, string voteName, address indexed owner);

    // Fonction pour créer un nouveau contrat Voting avec un owner spécifié
    function createVoting(string memory _voteName, address _owner) public {
        Voting newVoting = new Voting(_voteName);
        newVoting.transferOwnership(_owner); // Transférer la propriété à _owner

        emit VotingCreated(address(newVoting), _voteName, _owner);
    }
}
