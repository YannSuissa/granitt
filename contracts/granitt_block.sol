pragma solidity ^0.5.3;
 
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Mintable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol";

//import { granitt_blocks } from "granitt_blocks.sol";
//import "granitt_utils.sol";

contract granitt_block is Initializable, ERC721Full, ERC721Mintable, 
  Ownable, ReentrancyGuard  
{

  //----------------------------------------
  //  Data 
  //----------------------------------------

  address         p_contract_owner;   // possessor of the block
  address         p_oracle1;          // ex : notary
  address         p_oracle2;          // for safety
  address         p_sale_address;     // Address of the sale contract
  uint256         p_block_id;         // block increment
  string          p_block_uri;        // ERC721 metadata


  //----------------------------------------
  //  init 
  //----------------------------------------

  function initialize() public initializer {
    ERC721.initialize();
    ERC721Enumerable.initialize();
    ERC721Metadata.initialize("Granitt_block_NFT", "GRNB");
    ERC721Mintable.initialize(msg.sender);
    p_contract_owner = msg.sender; // The Sender is the Owner; Ethereum Address of the Owner
  }

  //----------------------------------------
  //  Block
  //----------------------------------------

  function init_block(address oracle1, address oracle2, address sale_address, 
      uint256 block_id, string memory block_uri) public {
      
      p_oracle1 = oracle1;
      p_oracle2 = oracle2;
      p_sale_address = sale_address;
      p_block_id = block_id;
      p_block_uri = block_uri;

      _mint(p_contract_owner, p_block_id);
      _setTokenURI(p_block_id, block_uri);

      //emit init_sale_event(id_new);
  }

  function get_block_info() public view 
    returns(address contract_owner, address oracle1, address oracle2, 
            address sale_address, uint256 block_id, 
            string memory block_uri)
  {
    return (p_contract_owner, 
            p_oracle1,
            p_oracle2, 
            p_sale_address, 
            p_block_id,
            p_block_uri);
  }

  function update_block_uri(string memory block_uri) nonReentrant public 
    returns (uint256) 
  {
    require((msg.sender == p_oracle1 || 
             msg.sender == p_oracle2), "Only oracles can change block infos");

    p_block_uri = block_uri;

    _setTokenURI(p_block_id, p_block_uri);
  }

  function update_oracle1(address oracle) nonReentrant public 
    returns (uint256) 
  {
    require(msg.sender == p_oracle1, "Only oracles can change block infos");
    require(oracle != p_oracle2, "Can't have oracle1 == oracle2");

    p_oracle1 = oracle;
  }
  
  function update_oracle2(address oracle) nonReentrant public 
    returns (uint256) 
  {
    require((msg.sender == p_oracle1 || 
             msg.sender == p_oracle2), "Only oracles can change block infos");

    require(oracle != p_oracle1, "Can't have oracle1 == oracle2");

    p_oracle2 = oracle;
  }
  
  // function get_increment(data_blocks storage self) internal view
  //   returns(uint256 block_increment)
  // {
  //   return (self.blocks.length);
  // }

  // function add_block(data_blocks storage self, address owner, 
  //   string memory block_uri) internal 
  //   returns (uint256) 
  // {
  //   uint256 id_new = self.blocks.length; // get_block_position_and_inc(self);
  //   granitt_block memory bl_new;
  //   self.blocks.push(bl_new);
  //   self.blocks[id_new].block_uri = block_uri;
  //   self.blocks[id_new].block_owner = owner;
  //   self.blocks[id_new].block_id = id_new;
  //   return (id_new);
  // }

  // function get_block_uri(data_blocks storage self, uint32 block_id) internal view
  //   returns(string memory block_uri)
  // {
  //   //require (block_id > self.block_increment, "id is bigger than existing blocks");
  //   //uint256 block_position = find_block_position_by_id(self, block_id);

  //   return(self.blocks[block_id].block_uri);
  // }

  // function get_block_owner(data_blocks storage self, uint32 block_id) internal view
  //   returns(address owner)
  // {
  //   //require (block_id > self.block_increment, "id is bigger than existing blocks");
  //   //uint256 block_position = find_block_position_by_id(self, block_id);

  //   return(self.blocks[block_id].block_owner);
  // }

}