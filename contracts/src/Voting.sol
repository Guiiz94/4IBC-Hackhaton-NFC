// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importez les contrats nécessaires depuis OpenZeppelin
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract Voting is Ownable, ReentrancyGuard, Pausable {
    struct Option {
        string name;
        uint voteCount;
    }

    string public voteName;
    Option[] public options;
    mapping(string => uint) private optionIndex;
    mapping(bytes32 => bool) private whitelistedNFCs;
    bool public votingClosedPermanently = false;

    // Événements
    event OptionAdded(string optionName);
    event VoteCast(string optionName, string nfcID);

    // Constructor
    constructor(string memory _voteName) Ownable(msg.sender) {
        voteName = _voteName;
    }

    function addToWhitelist(string[] memory nfcIDs) public onlyOwner {
        for (uint i = 0; i < nfcIDs.length; i++) {
            whitelistedNFCs[keccak256(abi.encodePacked(nfcIDs[i]))] = true;
        }
    }

    function addOption(string memory _optionName) public nonReentrant onlyOwner whenNotPaused{
        require(optionIndex[_optionName] == 0, "Option already exists");
        require(!votingClosedPermanently, "Voting has been closed permanently");

        options.push(Option(_optionName, 0));
        optionIndex[_optionName] = options.length;

        emit OptionAdded(_optionName);
    }

    function castVote(string memory _optionName, string memory nfcID) public nonReentrant whenNotPaused {
        require(!votingClosedPermanently, "Voting has been closed permanently");
        require(whitelistedNFCs[keccak256(abi.encodePacked(nfcID))], "NFC ID not whitelisted");
        uint index = optionIndex[_optionName];
        require(index != 0, "Option does not exist");
        
        options[index - 1].voteCount += 1;

        emit VoteCast(_optionName, nfcID);
    }
    
    function getOptions() public view returns (string[] memory names, uint[] memory voteCounts) {
        require(!votingClosedPermanently, "Voting has been closed permanently");

        names = new string[](options.length);
        voteCounts = new uint[](options.length);

        for (uint i = 0; i < options.length; i++) {
            names[i] = options[i].name;
            voteCounts[i] = options[i].voteCount;
        }
    }

    function pause() public nonReentrant onlyOwner {
        require(!votingClosedPermanently, "Voting has been closed permanently");
        _pause();
    }

    function unpause() public nonReentrant onlyOwner {
        require(!votingClosedPermanently, "Voting cannot be reopened after being closed permanently");
        _unpause();
    }

    function closeVotePermanently() public nonReentrant onlyOwner {
        votingClosedPermanently = true;
        _pause(); 
    }
}
