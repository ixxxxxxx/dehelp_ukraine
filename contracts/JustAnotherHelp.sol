//SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

/**
 * Ukraine people deserves this ❤
 */
contract JustAnotherHelp {

    uint256 public count = 0;

    struct Donation{
        uint256 id;
        address donator;
        uint256 quantity;
        string  contact;
        address grantee;
        bool    exists;
    }

    mapping(uint256 => Donation) private donations;

    modifier isDonator(uint256 _donationId){
        Donation storage d = donations[_donationId];
        require(d.donator == msg.sender, "Not the donator");
        _;
    }

    modifier isGrantee(uint256 _donationId){
        Donation storage d = donations[_donationId];
        require(d.grantee == msg.sender, "Not the grantee");
        _;
    }

    event DonationAdded(
        uint256 indexed id,
        address donator,
        uint256 quantity
    );

    event GranteeAdded(
        uint256 indexed id,
        string contact,
        address grantee
    );

    event ContactChanged(
        uint256 indexed id,
        address grantee,
        string contact
    );

    event DonationRetired(
        uint256 indexed id,
        uint256 quantity,
        address donator
    );

    event DonationDone(
        uint256 indexed id,
        address donator,
        address grantee,
        uint256 quantity
    );

    function addDonation() public payable {
        require(msg.value > 0, "Should be greater than zero");
        count++;
        Donation storage d = donations[count];

        d.id        = count; 
        d.donator   = msg.sender;
        d.quantity  = msg.value;
        d.exists    = true;
        d.contact   = "";
        d.grantee   = address(0);

        emit DonationAdded(count, msg.sender, msg.value);
    }

    function addGrantee(uint256 _donationId, string calldata _contact) public {
        Donation storage d = donations[_donationId];
        require(d.grantee == address(0), "Active donation");
        require(d.exists, "No donation created");
        d.contact = _contact;
        d.grantee = msg.sender;

        emit GranteeAdded(_donationId, _contact, msg.sender);
    }

    function changeContact(uint256 _donationId, string calldata _contact) public isGrantee(_donationId){
        Donation storage d = donations[_donationId];
        d.contact = _contact;

        emit ContactChanged(_donationId, msg.sender, _contact);
    }

    function retireDonation(uint256 _donationId) public payable isDonator(_donationId){
        Donation storage d = donations[_donationId];
        uint256 _quantity = d.quantity;
        _clearDonation(_donationId);
        payable(msg.sender).transfer(_quantity);

        emit DonationRetired(_donationId, _quantity, msg.sender);
    }

    function doDonation(uint256 _donationId) public payable isDonator(_donationId) {
        Donation storage d = donations[_donationId];
        require(d.grantee != address(0), "Grantee is zero address");
        uint256 _quantity = d.quantity;
        address _grantee = d.grantee;
        _clearDonation(_donationId);
        payable(_grantee).transfer(_quantity);

        emit DonationDone(_donationId, msg.sender, _grantee, _quantity);
    }

    function _clearDonation(uint256 _donationId) private {
        Donation storage d = donations[_donationId];
        d.donator = address(0);
        d.quantity = 0;
        d.exists = false;
        d.contact = "";
        d.grantee = address(0);
    }

    function getAllDonations() public view returns(Donation[] memory){
        Donation[] memory allDonations = new Donation[](count);
        uint c = 0;
        for (uint256 index = 1; index <= count; index++) {
            Donation storage d = donations[index];
            if (d.exists){
                allDonations[c] = d;
                c++;
            }
        }

        return allDonations;
    }

    function getDonation(uint256 _donationId) public view returns(Donation memory){
        return donations[_donationId];
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
