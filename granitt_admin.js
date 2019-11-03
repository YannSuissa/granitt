"use strict";

window.addEventListener('load', async () => {

  var granitt = new granitt_contract(
    "0x26b4AFb60d6C903165150C6F0AA14F8016bE4aec",
    "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1",
    'http://localhost:8545');

  try {
    // Request account access if needed
    
    await granitt.init();

    //----------------------------------------
    //  get the number of sales
    //----------------------------------------
    //setInterval(function (){ 
    let sale_number = await granitt.get_sales_count(); 
    console.log("Number of sales : ", sale_number);
    //}, 3000);

    //----------------------------------------
    //  create a sale
    //----------------------------------------
    let sale_id = await granitt.create_sale(
      granitt.current_addr, "vente", 'https://url.link/salex', 50);
      console.log("New sale id : ", sale_id);

    //----------------------------------------
    //  get sale info
    //----------------------------------------
    let sale_info = await granitt.get_sale_info(sale_id);
    console.log("Sale info : ", sale_info);

    //----------------------------------------
    //  create a block
    //----------------------------------------
    let block_id = await granitt.create_block(
      granitt.current_addr, sale_id, 'https://url.link/block_' + sale_id);
    console.log("New block id : ", block_id);

    //----------------------------------------
    //  get block info
    //----------------------------------------
    let block_uri = await granitt.get_block_uri(sale_id, block_id);
    console.log("block uri : ", block_uri);
    let block_owner = await granitt.get_block_owner(sale_id, block_id);
    console.log("block owner : ", block_owner);

    var elm = document.getElementById("message");
    elm.innerHTML += sale_info;
  } catch (error) {
    console.log(error);
    // User denied account access...
  }

});

