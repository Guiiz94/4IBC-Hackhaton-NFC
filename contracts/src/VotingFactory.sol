// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Voting.sol";

contract VotingFactory {
    Voting[] public votings;

    event VotingDeployed(address indexed votingAddress);

    // Fonction pour déployer un nouveau contrat de vote.
    function createVoting() public {
        Voting newVoting = new Voting();
        // Qui peut créer un vote ?
        newVoting.transferOwnership(msg.sender); // Transfert de propriété au créateur du vote
        votings.push(newVoting);
        emit VotingDeployed(address(newVoting));
    }
}