// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Filing {
    address public owner;
    address[] private filers;
    uint256 public fillingFee;

    struct FilingInfo{
        address filingOwner;
        string securedInterestType;
        uint256 partySize;
        string contractNumber;
        uint256 valueOfLoan;
        string securingPartyType;
        string securingPartyFullname;
        string securingPartyNationalID;
        string securedPartyName;
        string securedPartyAddress;
        string securedPartyCountry;
        string collateralCategory;
        string collateralDescription;
        uint256 timestamp;
    } 

    constructor(uint256 _fillingFee){
        owner = msg.sender;
        fillingFee = _fillingFee;
    }

    mapping(address => FilingInfo[]) private filings;

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function submitFilingInfo(
        string memory _securedInterestType,
        uint256 _partySize,
        string memory _contractNumber,
        uint256 _valueOfLoan,
        string memory _securingPartyType,
        string memory _securingPartyFullname,
        string memory _securingPartyNationalID,
        string memory _securedPartyName,
        string memory _securedPartyAddress,
        string memory _securedPartyCountry,
        string memory _collateralCategory,
        string memory _collateralDescription
    ) public payable {
        require(msg.value == fillingFee, "Incorrect Amount");

        if(filings[msg.sender].length == 0){
            filers.push(msg.sender);
        }

        FilingInfo memory newFiling = FilingInfo({
            filingOwner: msg.sender,
            securedInterestType: _securedInterestType,
            partySize: _partySize,
            contractNumber: _contractNumber,
            valueOfLoan: _valueOfLoan,
            securingPartyType: _securingPartyType,
            securingPartyFullname: _securingPartyFullname,
            securingPartyNationalID: _securingPartyNationalID,
            securedPartyName: _securedPartyName,
            securedPartyAddress: _securedPartyAddress,
            securedPartyCountry: _securedPartyCountry,
            collateralCategory: _collateralCategory,
            collateralDescription: _collateralDescription,
            timestamp: block.timestamp
        });

        filings[msg.sender].push(newFiling);
    }

    function getAllFilings(address _owner) public onlyOwner view returns (FilingInfo[] memory) {
        require(owner== _owner, "You are not the owner");
        uint256 totalFilings = 0;

        for (uint256 i = 0; i < filers.length; i++) {
            totalFilings += filings[filers[i]].length;
        }

        FilingInfo[] memory allFilings = new FilingInfo[](totalFilings);
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < filers.length; i++) {
            FilingInfo[] storage userFilings = filings[filers[i]];
            for (uint256 j = 0; j < userFilings.length; j++) {
                allFilings[currentIndex] = userFilings[j];
                currentIndex++;
            }
        }

        return allFilings;
    }

    function getAllFilers() public view onlyOwner returns (address[] memory) {
        return filers;
    }

    function getFilingByOwner(address _owner) public view onlyOwner returns (FilingInfo[] memory) {
        return filings[_owner];
    }

    function getFiling(uint _id) public view returns (FilingInfo memory){
        return filings[msg.sender][_id];
    }
}