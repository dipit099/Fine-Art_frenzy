pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract is ERC721 {
  address[] public artists;
  address[] public buyers;
  address[] public verifiers;
  uint256 public unsoldArtWorkCount = 0;
  uint256 public soldArtWorkCount = 0;
  uint256 public unverifiedNormalArtWorkCount = 0;
  uint256 public unverifiedAuctionedArtworkCount = 0;
  uint256 public totalArtWorkCount = 0;
  uint256 public auctionedArtWorkCount = 0;
  uint256 public normalArtWorkCount = 0;
  string public helloWorld;
  constructor() ERC721("ArtWork", "ART") {
    helloWorld = "Hello World!";
  }
  function getWorld() public virtual returns (string memory) {
    return helloWorld;
  }
  function setWorld(string memory _name) public {
    helloWorld = _name;
  }

  function addArtist(address _artist) public {
    artists.push(_artist);
  }
  function addBuyer(address _buyer) public {
    buyers.push(_buyer);
  }
  function addVerifier(address _verifier) public {
    verifiers.push(_verifier);
  }
  function getArtists() public view returns (address[] memory) {
    return artists;
  }
  function getBuyers() public view returns (address[] memory) {
    return buyers;
  }
  function getVerifiers() public view returns (address[] memory) {
    return verifiers;
  }
  struct ArtWork {
    string title;
    string description;
    string image;
    uint256 price;
    address artist;
    address buyer;
    address verifier;
    bool isVerified;
    bool isSold;
    string typeOfWork;
  }
  struct AuctionedArtworks {
    string title;
    string description;
    string image;
    uint256 basePrice;
    uint256 highestBid;
    address highestBidder;
    uint256 deadline;
    address artist;
    bool isVerified;
    bool isSold;
    string typeOfWork;
  }
  ArtWork[] public artWorks;
  AuctionedArtworks[] public auctionedArtworks;
  mapping(uint256 => ArtWork) public artWorkIdToArtWork;
  mapping(uint256 => AuctionedArtworks) public artWorkIdToAuctionedArtwork;
  ArtWork[] public unverifiedNormalArtWorks;
  AuctionedArtworks[] public unverifiedAuctionedArtworks;

  function createNormalArtWork(
    string memory _title, 
    string memory _description,
    string memory _image, 
    uint256 _price,
    string memory _typeOfWork
    ) 
    public {
    ArtWork memory newArtWork = ArtWork(_title, _description, _image, _price, msg.sender, address(0), address(0), false, false, _typeOfWork);
    unverifiedNormalArtWorks.push(newArtWork);
    artWorkIdToArtWork[totalArtWorkCount] = newArtWork;
    _safeMint(msg.sender, totalArtWorkCount);
    totalArtWorkCount++;
    unsoldArtWorkCount++;
    unverifiedNormalArtWorkCount++;
  }

  function createAuctionedArtwork(
    string memory _title,
    string memory _description,
    string memory _image,
    uint256 _deadline,
    uint256 _basePrice,
    string memory _typeOfWork
    )
    public {
      AuctionedArtworks memory newAuctionedArtwork = AuctionedArtworks(_title, _description, _image,_basePrice, 0, address(0), _deadline, msg.sender, false, false, _typeOfWork);
      artWorkIdToAuctionedArtwork[totalArtWorkCount] = newAuctionedArtwork;
      unverifiedAuctionedArtworks.push(newAuctionedArtwork);
      _safeMint(msg.sender, totalArtWorkCount);
      totalArtWorkCount++;
      unsoldArtWorkCount++;
      unverifiedAuctionedArtworkCount++;
    }
  function getArtWork(uint256 _artWorkId) public view returns (ArtWork memory) {
    return artWorkIdToArtWork[_artWorkId];
  }
  function getArtWorks() public view returns (ArtWork[] memory) {
    return artWorks;
  }
  function getUnverifiedNormalArtWorks() public view returns (ArtWork[] memory) {
    return unverifiedNormalArtWorks;
  }
  function getUnverifiedAuctionedArtWorks() public view returns (AuctionedArtworks[] memory) {
    return unverifiedAuctionedArtworks;
  }
  function buyArtWork(uint256 _artWorkId) public payable {
    require(_exists(_artWorkId), "Artwork does not exist");
    require(artWorkIdToArtWork[_artWorkId].isVerified == true, "Artwork not verified");
    require(msg.value >= artWorkIdToArtWork[_artWorkId].price, "Not enough funds sent");
    require(artWorkIdToArtWork[_artWorkId].isSold == false, "Artwork already sold");
    artWorkIdToArtWork[_artWorkId].isSold = true;
    artWorkIdToArtWork[_artWorkId].buyer = msg.sender;
    (bool sent, ) = artWorkIdToArtWork[_artWorkId].artist.call{value: artWorkIdToArtWork[_artWorkId].price}("");
    require(sent, "Failed to send Ether");
    _transfer(artWorkIdToArtWork[_artWorkId].artist, msg.sender, _artWorkId);
    unsoldArtWorkCount--;
    soldArtWorkCount++;
  }
  function verifyNormalArtWork(uint256 _artWorkId) public {
    require(_exists(_artWorkId), "Artwork does not exist");
    require(artWorkIdToArtWork[_artWorkId].isVerified == false, "Artwork already verified");
    artWorkIdToArtWork[_artWorkId].isVerified = true;
    artWorkIdToArtWork[_artWorkId].verifier = msg.sender;
    _approve(msg.sender, _artWorkId);
    unverifiedNormalArtWorkCount--;
    normalArtWorkCount++;
    artWorks.push(artWorkIdToArtWork[_artWorkId]);
    unverifiedNormalArtWorks.pop();
  }
  function verifyAuctionedArtWork(uint256 _artWorkId) public {
    require(_exists(_artWorkId), "Artwork does not exist");
    require(artWorkIdToAuctionedArtwork[_artWorkId].isVerified == false, "Artwork already verified");
    artWorkIdToAuctionedArtwork[_artWorkId].isVerified = true;
    _approve(msg.sender, _artWorkId);
    unverifiedAuctionedArtworkCount--;
    auctionedArtWorkCount++;
    auctionedArtworks.push(artWorkIdToAuctionedArtwork[_artWorkId]);
    unverifiedAuctionedArtworks.pop();
  }
  function auctionBid(address _buyer, uint256 _artWorkId) public payable{
    require(_exists(_artWorkId), "Artwork does not exist");
    require(artWorkIdToArtWork[_artWorkId].isVerified == true, "Artwork not verified");
    require(artWorkIdToArtWork[_artWorkId].isSold == false, "Artwork already sold");
    require(msg.value > artWorkIdToAuctionedArtwork[_artWorkId].highestBid, "Bid too low");
    require(block.timestamp < artWorkIdToAuctionedArtwork[_artWorkId].deadline, "Auction ended");
    artWorkIdToAuctionedArtwork[_artWorkId].highestBid = msg.value;
    artWorkIdToAuctionedArtwork[_artWorkId].highestBidder = _buyer;
  }
  function getAuctionedArtWorks() public view returns (AuctionedArtworks[] memory) {
    return auctionedArtworks;
  }
  function getAuctionedArtWork(uint256 _artWorkId) public view returns (AuctionedArtworks memory) {
    return artWorkIdToAuctionedArtwork[_artWorkId];
  }
  function receiveArtWorkAfterDeadline(uint256 _artWorkId) public payable{
    require(_exists(_artWorkId), "Artwork does not exist");
    require(artWorkIdToArtWork[_artWorkId].isVerified == true, "Artwork not verified");
    require(artWorkIdToArtWork[_artWorkId].isSold == false, "Artwork already sold");
    require(block.timestamp > artWorkIdToAuctionedArtwork[_artWorkId].deadline, "Auction not ended");
    artWorkIdToArtWork[_artWorkId].isSold = true;
    artWorkIdToArtWork[_artWorkId].buyer = artWorkIdToAuctionedArtwork[_artWorkId].highestBidder;
    (bool sent, ) = artWorkIdToArtWork[_artWorkId].artist.call{value: artWorkIdToAuctionedArtwork[_artWorkId].highestBid}("");
    require(sent, "Failed to send Ether");
    _transfer(artWorkIdToArtWork[_artWorkId].artist, artWorkIdToAuctionedArtwork[_artWorkId].highestBidder, _artWorkId);
    unsoldArtWorkCount--;
    soldArtWorkCount++;
  }
}
