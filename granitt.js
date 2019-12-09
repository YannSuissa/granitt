"use strict";

class granitt_contract
{
  //----------------------------------------
  //  init 
  //----------------------------------------

  constructor(contract_addr, current_addr, rpc_url)
  {
    this.contract = null;
    this.contract_addr = contract_addr;
    this.current_addr = current_addr;
    this.rpc_url = rpc_url;

    //await this.init();
  }

  init = async () => {

    //window.web3 = new Web3(ethereum);
    window.web3 = new Web3(new Web3.providers.HttpProvider(this.rpc_url));
    window.web3.eth.defaultAccount = window.web3.eth.accounts[0];
    //await ethereum.enable();

    await abiload();
    this.contract = new web3.eth.Contract(gl_contract_abi, this.contract_addr, 
      {transactionConfirmationBlocks: 3});
    
    //accounts = await web3.eth.getAccounts();    
    //console.log(accounts);
  }

  
  //----------------------------------------
  //  Sales
  //----------------------------------------

  create_sale = async (owner_addr, sale_name, uri, block_number) => {

    console.log("create sale start...");
    let ret = await this.contract.methods.create_sale(
      owner_addr, sale_name, uri, block_number).send({               
        from: this.current_addr, 
        gas: 500000, 
        gasPrice: 1e6
      });
    
    //console.log("create sale done : ", ret.events);

    return ret.events.sale_create_event.returnValues._id_new;
  }

  update_sale = async (sale_id, sale_name, uri) => {

    console.log("update sale start...");
    let ret = await this.contract.methods.update_sale(
      sale_id, sale_name, uri).send({               
        from: this.current_addr, 
        gas: 2000000, 
        gasPrice: 1e6
      });
    
    //console.log("create sale done : ", ret.events);

    //return ret.events.sale_create_event.returnValues._id_new;
  }

  get_sale_info = async (sale_id) => {
    let info = await this.contract.methods.get_sale_info(sale_id).call();
    //console.log("sale info", info);     
    return info;
  }

  get_sales_count = async () => {
    let count = await this.contract.methods.get_sales_count().call();
    //console.log("sale count", count);     
    return count;
  } 
  
  //----------------------------------------
  //  Block
  //----------------------------------------

  create_block = async (owner_addr, sale_id, block_uri) => {

    console.log("create block start...");
    let ret = await this.contract.methods.create_block(
      owner_addr, sale_id, block_uri).send({               
        from: this.current_addr, 
        gas: 500000, 
        gasPrice: 1e6
      });
    console.log(ret.events);
    let ev = ret.events.block_create_event.returnValues;

    console.log("create block done : id ", ev._id_new, " for sale_id : ", ev._sale_id);

    return ev._id_new;
  }

  get_block_uri = async (sale_id, block_id) => {
    let info = await this.contract.methods.get_block_uri(sale_id, block_id).call();
    //console.log("sale info", info);     
    return info;
  }

  get_block_owner = async (sale_id, block_id) => {
    let info = await this.contract.methods.get_block_owner(sale_id, block_id).call();
    console.log("sale info", info);     
    return info;
  }



};



// WEB3.JS COMPLETE DOC
// https://www.dappuniversity.com/articles/web3-js-intro

// nodejs ubuntu update
// https://askubuntu.com/questions/426750/how-can-i-update-my-nodejs-to-the-latest-version





// window.addEventListener('load', async () => {
//   var contract;
//   const contractAddress = "0xA57B8a5584442B467b4689F1144D269d096A3daF";
//   const main_account = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1";
//   var accounts
  
//   const init = async () => {
//     await abiload();
//     contract = new web3.eth.Contract(gl_contract_abi, contractAddress, 
//       {transactionConfirmationBlocks: 3});
//     accounts = await web3.eth.getAccounts();
//     console.log(accounts);
//   }

//   const create_sale = async () => {

//     console.log("create start...");
//     let idnew = await contract.methods.create_sale(
//       accounts[0], 
//       'vente', 
//       'https://url.link/', 
//       50).send({               
//         from: accounts[0], 
//         gas: 500000, 
//         gasPrice: 1e6
//       });

//     console.log("create done : ", idnew);
//     return idnew;
//   }

//   const get_sales_count = async () => {


//     //call({from: '0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1', gas: 100000});
//     // console.log("message", message);
//     //let message = await contract.methods.getMessage().call();
//     // console.log("message", message);

//     let count = await contract.methods.get_sales_count().call();
//     console.log("sale count", count); 
    
//     //message = await contract.methods.getMessage().call();
//     //await contract.methods.setMessage(message + " hello").send({ from: '0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1', gas: 500000, gasPrice: 1e6 });
//     //message = await contract.methods.getMessage().call();
//     //console.log("message", message);
//     return count;
//   } 
//   // Modern dapp browsers...
//   //if (window.ethereum) {  
//     //window.web3 = new Web3(ethereum);
//     window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
//     window.web3.eth.defaultAccount = window.web3.eth.accounts[0];
//     try {
//       // Request account access if needed
//       //await ethereum.enable();
//       await init();

//       setInterval(function (){ 
//         get_sales_count(); 
//       }, 3000);

//       //await get_sales_count();
//       await create_sale();
//       //await get_sales_count();
//       var elm = document.getElementById("message");
//       elm.innerHTML += message;
//     } catch (error) {
//       console.log(error);
//       // User denied account access...
//     }
//   //}
//   // Non-dapp browsers...
//   //else {
//     //console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
//   //}
// });