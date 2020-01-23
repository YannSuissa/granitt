pragma solidity ^0.5.3;
//pragma solidity ^0.6.0;
 
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Mintable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol";

//import { granitt_blocks } from "granitt_blocks.sol";
//import "granitt_utils.sol";


//import "@openzeppelin/contracts-ethereum-package/contracts/drafts/Counters.sol";

contract granitt_sale is Initializable, ERC721Full, ERC721Mintable, 
  Ownable, ReentrancyGuard  
{
  //using granitt_utils for string;
  //using granitt_blocks for granitt_blocks.data_blocks;

  //----------------------------------------
  //  Data 
  //----------------------------------------

  //struct            granitt_sale {
  address         p_contract_owner;   // contract creator
  address         p_oracle;           // ex : notary
  string          p_name;             // Name of the project
  uint256         p_sale_id;          // Sale id (from granitt database)
  uint32          p_block_numbers;    // total number of blocks
  //uint32          block_increment;  // number of blocks that have been minted
  string          p_sale_uri;         // ERC721 metadata
  string[]        p_sale_docs;        // GRANITT metadata URLs
  address[]       p_blocks;           // list of block address
  //}

  //mapping(uint256 => granitt_sale) private sales_block;
  //uint256[] sales_block_list;
  //sale_block[] public sales_block; // First Item has Index 0

  //uint256 private sales_counter;
  //uint256 private blocks_counter;

  //address         contract_owner;

  //----------------------------------------
  //  init 
  //----------------------------------------

  function initialize() public initializer {
    ERC721.initialize();
    ERC721Enumerable.initialize();
    ERC721Metadata.initialize("GranittNFT", "GRN");
    ERC721Mintable.initialize(msg.sender);
    p_contract_owner = msg.sender; // The Sender is the Owner; Ethereum Address of the Owner
  }

  //----------------------------------------
  //  Events
  //----------------------------------------

  // event init_sale_event(
  //   uint256 _id_new
  // );

  // event block_add_event(
  //     address _block_address,
  // );

  //----------------------------------------
  //  Sale
  //----------------------------------------

  function init_sale(address oracle, string memory name, uint256 sale_id,
      string memory sale_uri, uint32 block_numbers) public {
      
      p_name = name;
      p_sale_id = sale_id;
      p_oracle = oracle;
      p_sale_docs.push(sale_uri);
      p_block_numbers = block_numbers;

      _mint(p_contract_owner, p_sale_id);
      _setTokenURI(p_sale_id, sale_uri);

      //emit init_sale_event(id_new);
  }


  // function get_sales_count() public view returns(uint256 count)
  // {
  //     return sales_block_list.length;
  // }

  function get_sale_info() public view 
    returns(address contract_owner, address oracle, string memory name, 
            uint32 block_numbers, uint256 block_increment, 
            string memory sale_uri, string memory sale_docs)
  {
    string memory sale_docs_list;
    string memory sep = ";";
    uint256 uri_len = p_sale_docs.length;

    for (uint256 i = 0; i < uri_len; i++) 
    {
      sale_docs_list = concat_str(sale_docs_list, p_sale_docs[i]);
      sale_docs_list = concat_str(sale_docs_list, sep);
    }

    return(p_contract_owner, 
           p_oracle,
           p_name, 
           p_block_numbers, 
           //p_gb.get_increment(),
           p_blocks.length,
           p_sale_uri,
           sale_docs_list);
  }

  function update_sale(string memory name, string memory sale_uri,
                       string memory sale_doc) nonReentrant public 
    returns (uint256) 
  {
    require((msg.sender == p_contract_owner || 
             msg.sender == p_oracle), "Only oracles can change sale infos");

    p_name = name;
    p_sale_uri = sale_uri;
    p_sale_docs.push(sale_doc);

    // uint256 len = sales_block[sale_id].sale_uri.length;
    // if (len > 0)
    //   sales_block[sale_id].sale_uri[len - 1] = sale_uri;
    // else
    //   sales_block[sale_id].sale_uri.push(sale_uri);

    _setTokenURI(p_sale_id, p_sale_uri);
  }

  function update_oracle(address oracle) nonReentrant public 
    returns (uint256) 
  {
    require(msg.sender == p_contract_owner, "Only contract owner can change the oracle");

    p_oracle = oracle;
  }
  
  //----------------------------------------
  //  Blocks
  //----------------------------------------

  // function get_block_counter_and_inc() private 
  //   returns (uint256) 
  // {
  //     uint256 id = blocks_counter;
  //     blocks_counter++;
  //     return id;
  // }

  function add_block(address block_address) nonReentrant public     
  {
    require((msg.sender == p_contract_owner || 
             msg.sender == p_oracle), "Only oracles can add blocks");

    //uint256 id_new = get_block_counter_and_inc();
    require (p_blocks.length < p_block_numbers,
             "Cant create more blocks");

    p_blocks.push(block_address);

    //_mint(owner, id_new);      
    //_setTokenURI(id_new, block_uri);

    //emit block_add_event(block_address);

  }

  function concat_str(string memory _a, string memory _b) public pure returns (string memory)
  {
    bytes memory bytes_a = bytes(_a);
    bytes memory bytes_b = bytes(_b);
    string memory length_ab = new string(bytes_a.length + bytes_b.length);
    bytes memory bytes_c = bytes(length_ab);
    uint k = 0;
    for (uint i = 0; i < bytes_a.length; i++) bytes_c[k++] = bytes_a[i];
    for (uint i = 0; i < bytes_b.length; i++) bytes_c[k++] = bytes_b[i];
    return string(bytes_c);
  }

  // function get_block_uri(uint256 sale_id, uint32 block_id) public view 
  //   returns(string memory block_uri)
  // {
  //   return(sales_block[sale_id].gb.get_block_uri(block_id));
  // }

  // function get_block_owner(uint256 sale_id, uint32 block_id) public view 
  //   returns(address block_owner)
  // {
  //   return(sales_block[sale_id].gb.get_block_owner(block_id));
  // }

  // function get_sale_increment(uint256 sale_id) public view 
  //   returns(uint256 block_increment)
  // {
  //   return(sales_block[sale_id].gb.get_increment());
  // }



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
