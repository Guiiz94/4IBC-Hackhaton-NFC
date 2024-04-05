// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    struct Option {
        string name;
        uint voteCount;
    }

    string public voteName;
    Option[] public options;
    mapping(string => uint) private optionIndex;

    event OptionAdded(string optionName);
    event VoteCast(string optionName);

    constructor(string memory _voteName, address initialOwner) Ownable(initialOwner) {
        voteName = _voteName;
    }


    function addOption(string memory _optionName) public onlyOwner {
        require(optionIndex[_optionName] == 0, "Option already exists");

        options.push(Option(_optionName, 0));
        optionIndex[_optionName] = options.length;

        emit OptionAdded(_optionName);
    }

    function castVote(string memory _optionName) public onlyOwner {
        uint index = optionIndex[_optionName];
        require(index != 0, "Option does not exist");
        
        options[index - 1].voteCount += 1;

        emit VoteCast(_optionName);
    }

    function getOptions() public view returns (string[] memory names, uint[] memory voteCounts) {
        names = new string[](options.length);
        voteCounts = new uint[](options.length);

        for (uint i = 0; i < options.length; i++) {
            names[i] = options[i].name;
            voteCounts[i] = options[i].voteCount;
        }
    }
}