// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    struct Option {
        string name;
        uint voteCount;
    }

    struct Vote {
        string name;
        Option[] options;
        mapping(string => uint) optionIndex; // Mappe un nom d'option à son index
    }

    constructor() Ownable(msg.sender) {
    }


    Vote[] public votes;

    event VoteCreated(string voteName);
    event OptionAdded(string voteName, string optionName);

    // Crée un nouveau vote
    function createVote(string memory _voteName) public onlyOwner {
        votes.push();
        Vote storage v = votes[votes.length - 1];
        v.name = _voteName;
        emit VoteCreated(_voteName);
    }

    // Ajoute une option à un vote existant
    function addOption(string memory _voteName, string memory _optionName) public onlyOwner {
        uint index = findVoteIndex(_voteName);
        require(index != type(uint).max, "Vote not found");
        
        Vote storage v = votes[index];
        require(v.optionIndex[_optionName] == 0, "Option already exists");
        
        v.options.push(Option(_optionName, 0));
        v.optionIndex[_optionName] = v.options.length;
        emit OptionAdded(_voteName, _optionName);
    }

    // Trouve l'index d'un vote par son nom
    function findVoteIndex(string memory _voteName) internal view returns (uint) {
        for (uint i = 0; i < votes.length; i++) {
            if (keccak256(bytes(votes[i].name)) == keccak256(bytes(_voteName))) {
                return i;
            }
        }
        return type(uint).max;
    }

    // Nouvelle fonction pour obtenir les détails d'un vote
    function getVoteDetails(uint index) public view returns (string memory name, string[] memory optionNames, uint[] memory voteCounts) {
        require(index < votes.length, "Vote not found");

        Vote storage vote = votes[index];
        name = vote.name;

        optionNames = new string[](vote.options.length);
        voteCounts = new uint[](vote.options.length);

        for (uint i = 0; i < vote.options.length; i++) {
            Option storage option = vote.options[i];
            optionNames[i] = option.name;
            voteCounts[i] = option.voteCount;
        }
    }
}
