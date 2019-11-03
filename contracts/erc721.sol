pragma solidity ^0.5.3;
 
import "@openzeppelin/upgrades/contracts/Initializable.sol";

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Mintable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol";

import { granitt_blocks } from "granitt_blocks.sol";
import "granitt_utils.sol";


//import "@openzeppelin/contracts-ethereum-package/contracts/drafts/Counters.sol";

contract Granitt is Initializable, ERC721Full, ERC721Mintable, 
  Ownable, ReentrancyGuard  
{
  using granitt_utils for string;
  using granitt_blocks for granitt_blocks.data_blocks;
  //----------------------------------------
  //  Data 
  //----------------------------------------

  struct            granitt_sale {
    address         creator;
    string          name;             // Name of the project
    uint256         sale_id;          // Sale id
    uint32          block_numbers;    // number of blocks
    //uint32          block_increment;  // number of blocks that have been minted
    string[]        sale_uri;         // metadata URL 
    granitt_blocks.data_blocks        gb;               // list of block
  }

  mapping(uint256 => granitt_sale) private sales_block;
  uint256[] sales_block_list;
  //sale_block[] public sales_block; // First Item has Index 0

  uint256 private sales_counter;
  uint256 private blocks_counter;

  address         contract_owner;

  //----------------------------------------
  //  init 
  //----------------------------------------

  function initialize() public initializer {
    ERC721.initialize();
    ERC721Enumerable.initialize();
    ERC721Metadata.initialize("GranittNFT", "GRN");
    ERC721Mintable.initialize(msg.sender);
    contract_owner = msg.sender; // The Sender is the Owner; Ethereum Address of the Owner
  }

  //----------------------------------------
  //  Events
  //----------------------------------------

  event sale_create_event(
      address _owner,
      uint256 _id_new
  );

  event block_create_event(
      address _owner,
      uint256 _sale_id,
      uint256 _id_new
  );

  //----------------------------------------
  //  Sales
  //----------------------------------------

  function create_sale(address owner, string memory name, 
      string memory sale_uri, uint32 block_numbers) public {
      
      uint256 id_new = sales_counter;
      sales_counter++; //increment after for the good total for sales.

      sales_block[id_new].creator = owner;
      sales_block[id_new].name = name;
      sales_block[id_new].sale_id = id_new;
      sales_block[id_new].block_numbers = block_numbers;
      //sales_block[id_new].gb.block_increment = 0;
      sales_block[id_new].sale_uri.push(sale_uri);

      sales_block_list.push(id_new);

      //_mint(owner, id_new);
      //_setTokenURI(id_new, sale_uri);

      emit sale_create_event(owner, id_new);
  }


  function get_sales_count() public view returns(uint256 count)
  {
      return sales_block_list.length;
  }

  function get_sale_info(uint256 sale_id) public view 
    returns(address creator, string memory name, uint32 block_numbers, 
            uint256 block_increment, string memory sale_uri)
  {
    string memory sale_uri_list;
    string memory sep = ";";
    uint256 uri_len = sales_block[sale_id].sale_uri.length;

    for (uint256 i = 0; i < uri_len; i++) 
    {
      sale_uri_list = sale_uri_list.concat_str(sales_block[sale_id].sale_uri[i]);
      sale_uri_list = sale_uri_list.concat_str(sep);
    }

    return(sales_block[sale_id].creator, 
           sales_block[sale_id].name, 
           sales_block[sale_id].block_numbers, 
           sales_block[sale_id].gb.get_increment(),
           //granitt_blocks.get_increment(sales_block[sale_id].gb),
           sale_uri_list);
  }

  function update_sale(uint256 sale_id, string memory name, 
                       string memory sale_uri) nonReentrant public 
    returns (uint256) 
  {
      require(msg.sender == sales_block[sale_id].creator || 
              msg.sender == contract_owner);

    sales_block[sale_id].name = name;
    uint256 len = sales_block[sale_id].sale_uri.length;
    sales_block[sale_id].sale_uri[len] = sale_uri;
    _setTokenURI(sale_id, sale_uri);
  }

  //----------------------------------------
  //  Blocks
  //----------------------------------------

  function get_block_counter_and_inc() private 
    returns (uint256) 
  {
      uint256 id = blocks_counter;
      blocks_counter++;
      return id;
  }

  function create_block(address owner, uint256 sale_id, 
                        string memory block_uri) nonReentrant public 
    returns (uint256) 
  {
    require(msg.sender == sales_block[sale_id].creator || 
            msg.sender == contract_owner);

    uint256 id_new = get_block_counter_and_inc();
    sales_block[sale_id].gb.create_block(owner, id_new, block_uri);

    _mint(owner, id_new);      
    _setTokenURI(id_new, block_uri);

    emit block_create_event(owner, sale_id, id_new);

    return id_new;
  }

  function get_block_uri(uint256 sale_id, uint256 block_id) public view 
    returns(string memory block_uri)
  {
    return(sales_block[sale_id].gb.get_block_uri(block_id));
  }

  function get_block_owner(uint256 sale_id, uint256 block_id) public view 
    returns(address block_owner)
  {
    return(sales_block[sale_id].gb.get_block_owner(block_id));
  }


  //----------------------------------------
  //  utilities
  //----------------------------------------




  // struct paper_block {
  //   string name;        // Name of the project
  //   uint block_number;  // number of blocks
  //   uint block_price;   // price of the block
  // }
  //       paper_blocks.push(paper_block(_name,5,1)); // Item ("Sword",5,1)

}


// exemple de maniplaution d'array
// https://ethereum.stackexchange.com/questions/12611/solidity-filling-a-struct-array-containing-itself-an-array

// solidity security
// https://yos.io/2018/10/20/smart-contract-vulnerabilities-and-how-to-mitigate-them/
