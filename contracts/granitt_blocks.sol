pragma solidity ^0.5.3;

//import "@openzeppelin/upgrades/contracts/Initializable.sol";
//import "@openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol";

library granitt_blocks {

  struct            granitt_block {
    address         block_owner;
    string          block_name;       // Name of the block
    uint256         block_id;         // block unique id (between all sales)
    uint32          block_position;   // block position in the sale
    string          block_uri;
  }

  struct data_blocks {
    mapping(uint256 => granitt_block)   blocks; // list of block
    //uint256[]       blocks_list;      // list for access 
    uint32          block_increment;  // number of blocks that have been minted
  }


  function find_block_position_by_id(data_blocks storage self, uint256 block_id) private view
    returns(uint256 block_postion)
  {
    for (uint256 i = 0; i < self.block_increment; i++) 
      if (self.blocks[i].block_id == block_id)
        return (i);
      
    require (1 == 0, "Can't find block block_id");
  }

  function get_increment(data_blocks storage self) internal view
    returns(uint256 block_increment)
  {
    return (self.block_increment);
  }

  function get_block_position_and_inc(data_blocks storage self) internal 
      returns (uint32) 
  {
      uint32 id = self.block_increment;
      self.block_increment++;
      return id;
  }

  function create_block(data_blocks storage self, address owner, 
    uint256 id_new, string memory block_uri) internal 
  {
      self.blocks[id_new].block_uri = block_uri;
      self.blocks[id_new].block_owner = owner;
      self.blocks[id_new].block_id = id_new;
      self.blocks[id_new].block_position = get_block_position_and_inc(self);
  }

  function get_block_uri(data_blocks storage self, uint256 block_id) internal view
    returns(string memory block_uri)
  {
    uint256 block_position = find_block_position_by_id(self, block_id);

    return(self.blocks[block_position].block_uri);
  }

  function get_block_owner(data_blocks storage self, uint256 block_id) internal view
    returns(address owner)
  {
    uint256 block_position = find_block_position_by_id(self, block_id);

    return(self.blocks[block_position].block_owner);
  }

}