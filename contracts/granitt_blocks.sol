pragma solidity ^0.5.3;

//import "@openzeppelin/upgrades/contracts/Initializable.sol";
//import "@openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol";

library granitt_blocks {

  struct            granitt_block {
    address         block_owner;
    string          block_name;       // Name of the block
    //uint256         block_id;         // block unique id (between all sales)
    uint256          block_id;   // block position in the sale
    string          block_uri;
  }

  struct data_blocks {
    granitt_block[]   blocks;
    //mapping(uint256 => granitt_block)   blocks; // list of block
    //uint256[]       blocks_list;      // list for access 
    //uint32          block_increment;  // number of blocks that have been minted
  }


  function get_increment(data_blocks storage self) internal view
    returns(uint256 block_increment)
  {
    return (self.blocks.length);
  }

  function create_block(data_blocks storage self, address owner, 
    string memory block_uri) internal 
    returns (uint256) 
  {
    uint256 id_new = self.blocks.length; // get_block_position_and_inc(self);
    granitt_block memory bl_new;
    self.blocks.push(bl_new);
    self.blocks[id_new].block_uri = block_uri;
    self.blocks[id_new].block_owner = owner;
    self.blocks[id_new].block_id = id_new;
    return (id_new);
  }

  function get_block_uri(data_blocks storage self, uint32 block_id) internal view
    returns(string memory block_uri)
  {
    //require (block_id > self.block_increment, "id is bigger than existing blocks");
    //uint256 block_position = find_block_position_by_id(self, block_id);

    return(self.blocks[block_id].block_uri);
  }

  function get_block_owner(data_blocks storage self, uint32 block_id) internal view
    returns(address owner)
  {
    //require (block_id > self.block_increment, "id is bigger than existing blocks");
    //uint256 block_position = find_block_position_by_id(self, block_id);

    return(self.blocks[block_id].block_owner);
  }

}