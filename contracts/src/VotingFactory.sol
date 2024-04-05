// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Voting.sol";

contract VotingFactory {
    event VotingCreated(address indexed votingAddress, string voteName, address indexed owner);

    function createVoting(string memory _voteName, address _owner, string[] memory _whitelist) public {
        Voting newVoting = new Voting(_voteName);
        newVoting.transferOwnership(msg.sender); 
        newVoting.addToWhitelist(_whitelist);
        newVoting.transferOwnership(_owner); 

        emit VotingCreated(address(newVoting), _voteName, _owner);
    }
}
