import ICRC7 "../src";
import Principal "mo:base/Principal";
import CandyTypesLib "mo:candy_0_3_0/types";
import Properties "mo:candy_0_3_0/properties";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Map "mo:map9/Map";
import Set "mo:map9/Set";
import Opt "mo:base/Option";
import CandyConv  "mo:candy_0_3_0/conversion";
import D "mo:base/Debug";
import Debug "mo:base/Debug";
import {test; testsys} "mo:test";
import Vec "mo:vector";

let testOwner = Principal.fromText("exoh6-2xmej-lux3z-phpkn-2i3sb-cvzfx-totbl-nzfcy-fxi7s-xiutq-mae");
let testOwnerAccount = {owner = testOwner; subaccount = null};
let testCanister = Principal.fromText("p75el-ys2la-2xa6n-unek2-gtnwo-7zklx-25vdp-uepyz-qhdg7-pt2fi-bqe");

let spender1 : ICRC7.Account = {owner = Principal.fromText("2dzql-vc5j3-p5nyh-vidom-fhtyt-edvv6-bqewt-j63fn-ovwug-h67hb-yqe"); subaccount = ?Blob.fromArray([1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])};
let spender2 : ICRC7.Account = {owner = Principal.fromText("32fn4-qqaaa-aaaak-ad65a-cai"); subaccount = ?Blob.fromArray([3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])};
let spender3 : ICRC7.Account = {owner = Principal.fromText("zfcdd-tqaaa-aaaaq-aaaga-cai"); subaccount = ?Blob.fromArray([5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])};
let spender4 : ICRC7.Account = {owner = Principal.fromText("x33ed-h457x-bsgyx-oqxqf-6pzwv-wkhzr-rm2j3-npodi-purzm-n66cg-gae"); subaccount = ?Blob.fromArray([7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])};
let spender5 : ICRC7.Account = {owner = Principal.fromText("dtnbn-kyaaa-aaaak-aeigq-cai"); subaccount = ?Blob.fromArray([9,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])};

let baseCollection = {
  symbol = ?"anft";
  name = ?"A Test NFT";
  description = ?"A Descripton";
  logo = ?"http://example.com/test.png";
  supply_cap = ?100;
  max_query_batch_size = ?102;
  max_update_batch_size = ?103;
  default_take_value = ?104;
  max_take_value = ?105;
  max_memo_size = ?512;
  permitted_drift = null;
  tx_window = null;
  allow_transfers = null;
  burn_account = null;
  deployer = testOwner;
  supported_standards = null;
};

let baseNFT : CandyTypesLib.CandyShared = #Class([
  {immutable=false; name="url"; value = #Text("https://example.com/1");}
]);

let baseNFTWithSubAccount : CandyTypesLib.CandyShared = #Class([
  {immutable=false; name="url"; value = #Text("https://example.com/1");}
]);

func get_canister() : Principal{
  return testCanister;
};

let init_time = 1700925876000000000 : Nat64;
var test_time = init_time : Nat64;
let one_day = 86_400_000_000_000: Nat64;
let one_hour = one_day/24: Nat64;
let one_minute = one_hour/60: Nat64;
let one_second = one_minute/60: Nat64;

func get_time() : Int{
  return Nat64.toNat(test_time);
};

func get_time64() : Nat64{
  return test_time;
};

func set_time(x : Nat64) : Nat64{
  test_time += x;
  return test_time;
};


var icrc7_migration_state = ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

let #v0_1_0(#data(icrc7_state_current)) = icrc7_migration_state; 

func get_icrc7_state(): ICRC7.CurrentState{
  return icrc7_state_current;
};

let base_environment= {
  canister = get_canister;
  get_time = get_time;
  refresh_state = get_icrc7_state;
  log = null;
  add_ledger_transaction = null;
  can_mint = null;
  can_burn = null;
  can_transfer = null;
  can_update = null;
};

test("symbol can be initialized and updated", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  assert(icrc7.get_ledger_info().symbol == ?"anft");

  ignore icrc7.update_ledger_info([#Symbol(?"updated")]);
  assert(icrc7.get_ledger_info().symbol == ?"updated");

});

test("name can be initialized", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  assert(icrc7.get_ledger_info().name == ?"A Test NFT");
  ignore icrc7.update_ledger_info([#Symbol(?"updated")]);
  assert(icrc7.get_ledger_info().symbol == ?"updated");
});

test("description can be initialized", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  assert(icrc7.get_ledger_info().description == ?"A Descripton");
  ignore icrc7.update_ledger_info([#Description(?"updated")]);
  assert(icrc7.get_ledger_info().description == ?"updated");
});

test("logo can be initialized", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  assert(icrc7.get_ledger_info().logo == ?"http://example.com/test.png");
  ignore icrc7.update_ledger_info([#Logo(?"updated")]);
  assert(icrc7.get_ledger_info().logo == ?"updated");
});

test("supply cap can be initialized", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  assert(icrc7.get_ledger_info().supply_cap == ?100);
  ignore icrc7.update_ledger_info([#SupplyCap(?1000)]);
  assert(icrc7.get_ledger_info().supply_cap == ?1000);
});

test("max_query_batch_size can be initialized", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  assert(icrc7.get_ledger_info().max_query_batch_size == 102);
  ignore icrc7.update_ledger_info([#MaxQueryBatchSize(1000)]);
  assert(icrc7.get_ledger_info().max_query_batch_size == 1000);
});

test("max_update_batch_size can be initialized", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  assert(icrc7.get_ledger_info().max_update_batch_size == 103);
  ignore icrc7.update_ledger_info([#MaxUpdateBatchSize(1000)]);
  assert(icrc7.get_ledger_info().max_update_batch_size == 1000);
});

test("default_take_value can be initialized", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  assert(icrc7.get_ledger_info().default_take_value == 104);
  ignore icrc7.update_ledger_info([#DefaultTakeValue(1000)]);
  assert(icrc7.get_ledger_info().default_take_value == 1000);
});

test("max_take_value can be initialized", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  assert(icrc7.get_ledger_info().max_take_value == 105);
  ignore icrc7.update_ledger_info([#MaxTakeValue(1000)]);
  assert(icrc7.get_ledger_info().max_take_value == 1000);
});


icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

test("ICRC7 contract initializes with correct default state", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  D.print(debug_show(icrc7.get_ledger_info()));
  assert(icrc7.get_ledger_info().symbol == ?"anft");
  assert(icrc7.get_ledger_info().name == ?"A Test NFT");
  assert(icrc7.get_ledger_info().description == ?"A Descripton");
  assert(icrc7.get_ledger_info().logo == ?"http://example.com/test.png");
  assert(icrc7.get_ledger_info().supply_cap == ?100);
  assert(icrc7.get_ledger_info().allow_transfers == true);
  assert(icrc7.get_ledger_info().max_query_batch_size == 102);
  assert(icrc7.get_ledger_info().max_update_batch_size == 103);
  assert(icrc7.get_ledger_info().default_take_value == 104);
  assert(icrc7.get_ledger_info().max_take_value == 105);
  assert(icrc7.get_collection_owner() == testOwner);
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);


testsys<system>("Query for token metadata by ID should return correct token metadata",  func <system>(){

  D.print("starting token metatdata test");
  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  // For this test to succeed, a token with `token_id` must have been minted,
  // and its metadata should be set in the state before querying.
  // This represents the 'Arrange' part of the test (Arrange-Act-Assert)
  let token_id = 1; // Assuming token ID `1` has been minted with known metadata
  let metadata = baseNFT;
  D.print("about to set" # debug_show(metadata));
  let nft = icrc7.set_nfts<system>(testOwner,[{
    token_id=token_id;
    override=true;
    metadata=metadata;
    owner= ?testOwnerAccount;
    memo=null;
    created_at_time=null;
  }],false);

  D.print("nft has been set" # debug_show(nft));
  
  let ?found_nft = icrc7.get_nft(token_id) else return assert(false);

  D.print("have an nft" # debug_show(found_nft));
  // Assert: The received metadata should match the expected metadata
  assert(CandyTypesLib.eq(CandyTypesLib.unshare(metadata), found_nft.meta));
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

testsys<system>("Query for batched token metadata by a list of IDs should return correct metadata for all queried tokens", func<system>() {

  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  // For this test to succeed, multiple tokens with `token_ids` must have been minted,
  // and their metadata should be set in the state before querying.
  // This represents the 'Arrange' part of the test (Arrange-Act-Assert)
  let token_ids = [1, 2, 3]; // Assuming tokens with IDs 1, 2, and 3 have been minted with known metadata
  let metadata1 = baseNFT;
  let #ok(metadata2) = Properties.updatePropertiesShared(CandyConv.candySharedToProperties(baseNFT), [{
    name = "url";
    mode = #Set(#Text("https://example.com/2"))
  }]) else return assert(false);

  let #ok(metadata3) = Properties.updatePropertiesShared(CandyConv.candySharedToProperties(baseNFT), [{
    name = "url";
    mode = #Set(#Text("https://example.com/3"))
  }]) else return assert(false);
  
  
  let nft1 = icrc7.set_nfts<system>(testOwner, [{token_id=1;override=true;metadata=metadata1;memo=null;created_at_time=null;owner = ?testOwnerAccount;}],false);
  let nft2 = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=2;override=true;metadata=#Class(metadata2);}],false);
  let nft3 = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=3;override=true;metadata=#Class(metadata3);}],false);

  let found_nfts = icrc7.get_token_infos(token_ids);

  // Assert: The received metadata for all queried tokens should match the expected metadata
  func findAndConvertToCandy(found_nfts: [(Nat, ?ICRC7.NFT)], targetNat: Nat) : CandyTypesLib.Candy {
    let foundItem = Array.find<(Nat, ?ICRC7.NFT)>(found_nfts, func(x : (Nat, ?ICRC7.NFT)) : Bool { x.0 == targetNat; });
    switch (foundItem) {
      case (?(_, ?foundTuple)) {
            foundTuple.meta  // Convert to Candy and return, replace with actual logic
      };
      case (_) { #Nat(0) };  // Return null if no match is found
        
    }
  };

  let foundItem = Array.find<(Nat, ?ICRC7.NFT)>(found_nfts, func(x : (Nat, ?ICRC7.NFT)) : Bool { x.0 == 1; });

  assert(
      switch (foundItem) {
          case (null) { false };  // Handle the case where no item is found
          case (?foundTuple) {
              // Assuming that foundTuple.1 is of type NFT and needs to be converted to Candy
              let ?candyFromNFT = foundTuple.1; // Replace with your actual conversion logic
              CandyTypesLib.eq(
                  CandyTypesLib.unshare(metadata1), 
                  candyFromNFT.meta  // Use the converted Candy type
              )
          };
      }
  );
  

  let baseNFT2 : CandyTypesLib.Candy = CandyTypesLib.unshare(#Class(metadata2));
  let candyFromNFT2 = findAndConvertToCandy(found_nfts, 2);
  assert(CandyTypesLib.eq(baseNFT2, candyFromNFT2));

  let baseNFT3 : CandyTypesLib.Candy = CandyTypesLib.unshare(#Class(metadata3));
  let candyFromNFT3 = findAndConvertToCandy(found_nfts, 3);
  assert(CandyTypesLib.eq(baseNFT3, candyFromNFT3));

});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

testsys<system>("Query for the owner of a specific token ID should return correct owner information", func<system>() {
  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  // For this test to succeed, a token with `token_id` must have been minted,
  // and its ownership information should be set in the state before querying.
  // This represents the 'Arrange' part of the test (Arrange-Act-Assert)
  let token_id = 1; // Assuming token ID `1` has been minted with known ownership information
  let metadata = baseNFT;
  let nft = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=token_id;override=true;metadata=metadata;}],false);
  
  
  // Act: Query the owner information for the specified token ID
  let ?ownerResponse = icrc7.get_token_owner(token_id) else return assert(false);
  D.print(debug_show(ownerResponse));



  // Assert: The received owner information should match the expected owner information
  assert(ICRC7.account_eq(ownerResponse, {owner = testOwner; subaccount = null}));

  //with sub account
  let token_id2 = 2; // Assuming token ID `1` has been minted with known ownership information
  let ownerSubaccount = Blob.fromArray([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]);
  let metadata2 = baseNFTWithSubAccount;
  let nft2 = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?{testOwnerAccount with subaccount = ?ownerSubaccount};token_id=token_id2;override=true;metadata=metadata2;}],false);
  
  
  // Act: Query the owner information for the specified token ID
  let ?ownerResponse2 = icrc7.get_token_owner(token_id2);
  D.print("have owner 2" # debug_show(ownerResponse2));

  
  // Assert: The received owner information should match the expected owner information
  assert(ICRC7.account_eq(ownerResponse2, {owner = testOwner; subaccount = ?ownerSubaccount}));
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

testsys<system>("Query for token ownership metadata directly from token metadata", func<system>() {
  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  // Sample token ID for testing
  let token_id = 1; // Assuming token ID `1` has been minted with known ownership information
  let metadata = baseNFTWithSubAccount;
  let nft = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=token_id; override=true;metadata=metadata;}],false);

  // Mockup metadata fetch from the ICRC7 contract
  let ?fetched_metadata = icrc7.get_nft(token_id) else return assert(false);

  let ?owner = fetched_metadata.owner else return assert(false);
  assert(ICRC7.account_eq({owner = testOwner; subaccount = null}, owner));
    
  
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

testsys<system>("Query for a list of token IDs owned by an account should return correct set of token IDs", func<system>() {
  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  // For this test to succeed, tokens must have been minted and assigned to the test owner account.
  // This represents the 'Arrange' part of the test (Arrange-Act-Assert)
  let token_ids = [1, 2, 3]; // Assuming tokens with IDs 1, 2, and 3 have been minted with known metadata
  let metadata1 = baseNFT;
  let #ok(metadata2) = Properties.updatePropertiesShared(CandyConv.candySharedToProperties(baseNFT), [{
    name = "url";
    mode = #Set(#Text("https://example.com/2"))
  }]) else return assert(false);

  let #ok(metadata3) = Properties.updatePropertiesShared(CandyConv.candySharedToProperties(baseNFT), [{
    name = "url";
    mode = #Set(#Text("https://example.com/3"))
  }]) else return assert(false);
  
  
  let nft1 = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=1;override=true;metadata=metadata1;}],false);
  let nft2 = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=null;token_id=2;override=true;metadata=#Class(metadata2)}],false);
  let nft3 = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=3;override=true;metadata=#Class(metadata3)}],false);

  D.print("nft 1 " # debug_show(metadata1));
  D.print("nft 2 " # debug_show(metadata2));
  D.print("nft 3 " # debug_show(metadata3));


  // Define expected set of token IDs owned by testOwner
  let expectedTokenIds = [1, 3];  // Replace with expected token IDs based on test scenario

  let ?result = icrc7.get_token_owners_tokens({owner=testOwner; subaccount=null}) else return assert(false);

  D.print("owner result" # debug_show(Set.toArray(result)));
  // Assert: The received list of token IDs should match the expected set
  assert(Array.equal<Nat>(Set.toArray(result), expectedTokenIds, Nat.equal));

  let count = icrc7.get_token_owners_tokens_count({owner=testOwner; subaccount=null});
  assert(2 == count);
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);


testsys<system>("Paginate through the list of tokens and receive the correct page of tokens", func<system>() {
  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  let token_ids = [1, 2, 3, 4, 5, 6, 7, 8 ,9, 10]; // Assuming tokens with IDs 1, 2, and 3 have been minted with known metadata
  let metadata1 = baseNFT;
  for(thisItem in token_ids.vals()){

    let #ok(metadata) = Properties.updatePropertiesShared(CandyConv.candySharedToProperties(baseNFT), [{
      name = "url";
      mode = #Set(#Text("https://example.com/" # Nat.toText(thisItem)))
    }]) else return assert(false);

    let nft = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=thisItem;override=true;metadata=#Class(metadata);}],false);

  };
  

  // Action: Paginate through the list of tokens with pagination parameters
  let page1 = icrc7.get_tokens_paginated(null, ?3);  // Get the first page containing 3 tokens
  let page2 = icrc7.get_tokens_paginated(?3, ?3);    // Get the second page containing the next 3 tokens

  D.print("pageinated results = " # debug_show(page1,page2));
  // Assert: Receive correct page of tokens for pagination
  assert(Array.equal<Nat>(page1,[1, 2, 3], Nat.equal));
  assert(Array.equal<Nat>(page2,[4, 5, 6], Nat.equal));
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

testsys<system>("Paginate through the list of tokens owned by an account", func<system>() {
  // Assuming ICRC7 class, base environment, and baseNFT are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  let account = testOwner; // Replace testOwner with the account whose tokens need pagination
  let expectedTokens1 = [1, 2, 3]; // Replace with the expected tokens for the given account
  let expectedTokens2 = [4, 5]; // Replace with the expected tokens for the given account
  let token_ids = [1, 2, 3, 4, 5, 6, 7, 8 ,9, 10]; // Assuming tokens with IDs 1, 2, and 3 have been minted with known metadata
  
  let metadata1 = baseNFT;
  for(thisItem in token_ids.vals()){

    let #ok(metadata) = Properties.updatePropertiesShared(CandyConv.candySharedToProperties(baseNFT), [{
      name = "url";
      mode = #Set(#Text("https://example.com/" # Nat.toText(thisItem)))
    },
    ]) else return assert(false);

    let nft = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=if(thisItem < 6){?testOwnerAccount;} else {null};token_id=thisItem;override=true;metadata=#Class(metadata);}],false);

  };

  // Act: Paginate through the list of tokens owned by the provided account
  let paginatedTokens1 = icrc7.get_tokens_of_paginated({owner = testOwner;subaccount = null}, null, ?3);
  let paginatedTokens2 = icrc7.get_tokens_of_paginated({owner = testOwner;subaccount = null}, ?3, ?3);
  D.print("pageinated results = " # debug_show(paginatedTokens1,paginatedTokens2));
  
  // Assert: The received paginated tokens should match the expected tokens
  assert(Array.equal(paginatedTokens1, expectedTokens1, Nat.equal));
  assert(Array.equal(paginatedTokens2, expectedTokens2, Nat.equal));
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);


testsys<system>("Transfer a token to another account", func<system>() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  
  // Arrange: Set up the necessary variables for the transfer
  let tokenOwner = testOwner; // Replace with appropriate owner principal
  let fromAccount = {owner = tokenOwner; subaccount = null}; // Replace with the appropriate owner's account
  let toAccount = {owner = testCanister; subaccount = null}; // Place the recipient's account
  
  let token_id = 1;  // Assuming token with ID 1 exists
  let metadata = baseNFT;
  D.print("about to set" # debug_show(metadata));
  let nft = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=token_id;override=true;metadata=metadata;}],false);
  
  // Act: Transfer the token from the `fromAccount` to the `toAccount`
  let transferArgs = [{
    from_subaccount = fromAccount.subaccount;
    to = toAccount;
    token_id = token_id;
    memo = ?Text.encodeUtf8("Transfer memo");
    created_at_time = ?test_time;  // Replace with the current timestamp
  }];

  D.print("about to transfer" # debug_show(transferArgs));

  let #ok(transferResults) = icrc7.transfer_tokens<system>(tokenOwner, transferArgs) else return assert(false);

  D.print("transfer" # debug_show(transferResults));

  // Assert: Check if the token is successfully transferred
  assert(
    transferResults.size() == 1
  ); // "A single token transfer result is received"

  assert(
    (switch(transferResults[0]) {
      case (?#Ok(val)) val;
      case (_) return assert(false);
    }) >= 0
  ); // "Transfer result for the token with ID 1"

  // Query for the owner of the token after transfer
  let ?ownerResponse = icrc7.get_token_owner(token_id);

  assert(ownerResponse.owner == toAccount.owner);
  assert(ownerResponse.subaccount == toAccount.subaccount);

   let tokens_of = icrc7.tokens_of(toAccount, null, null);

  assert(tokens_of[0] == 1);

  let tokens_of2 = icrc7.tokens_of(testOwnerAccount, null, null);

  assert(tokens_of2.size() == 0);

    
  
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

testsys<system>("Reject Transfer Attempt by Unauthorized User", func<system>() {
  // Arrange: Set up the ICRC7 instance, current test environment, and required variables
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  let token_id = 1;  // Assuming token with ID 1 exists
  let metadata = baseNFT;
  D.print("about to set" # debug_show(metadata));
  let nft = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=token_id;override=true;metadata=metadata;}],false);


  let unauthorizedOwner = spender1;  // Replace with an unauthorized owner principal
  let unauthorizedTransferArgs = [{
    from_subaccount = unauthorizedOwner.subaccount;
    to = spender2;
    memo = ?Text.encodeUtf8("Unauthorized transfer attempt");
    token_id = 1;  // Replace with appropriate token ID for a token that the unauthorized owner owns
    created_at_time = ?init_time : ?Nat64;  // Replace with appropriate creation timestamp
  }];

  let transferResult = icrc7.transfer_tokens<system>(unauthorizedOwner.owner, unauthorizedTransferArgs);

  D.print("transferResult" # debug_show(transferResult));

  // Act: Attempt to transfer a token by an unauthorized user
  let #ok(transferResponses) = transferResult else return assert(false);

  // Assert: Check if the transfer attempt is rejected
  assert(
    transferResponses.size() == 1
  ); //"Exactly one transfer response"
  assert(
    (switch(transferResponses[0]) {
      case (?#Err(err)) true;
      case (?#Ok(val)) false;
    })
  ); //"Transfer attempt is rejected"
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);


testsys<system>("Update the metadata for the ledger", func<system>() {
  // Arrange: Setup the ICRC7 instance with the initial state
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  let newSymbol = "anft_updated";
  let newName = "Updated Test NFT";
  let newDescription = "An Updated Descripton";
  let newLogo = "http://example.com/updated.png";
  let newLedgerInfo = [
    #Symbol(?"anft_updated"),
    #Name(?"Updated Test NFT"),
    #Description(?"An Updated Descripton"),
    #Logo(?"http://example.com/updated.png")
  ];

  // Act: Update the metadata for the ledger
  ignore icrc7.update_ledger_info(newLedgerInfo);

  // Assert: Check if the ledger info is updated properly
  assert(icrc7.get_ledger_info().symbol == ?"anft_updated"); // "Symbol is updated correctly"
  assert(icrc7.get_ledger_info().name == ?"Updated Test NFT"); // "Name is updated correctly"
  assert(icrc7.get_ledger_info().description == ?"An Updated Descripton"); // "Description is updated correctly"
  assert(icrc7.get_ledger_info().logo == ?"http://example.com/updated.png"); // "Logo is updated correctly"
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

testsys<system>("Set metadata for a new NFT token", func<system>() {
  // Arrange: Set up the ICRC7 instance and required parameters
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  let token_id = 11;  // Assuming a new token ID
  let metadata = baseNFT;  // Define the metadata for the new NFT

  // Act: Set the metadata for the new NFT token
  let nftResult = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=token_id;override=true;metadata=metadata;}],false);

  // Assert: Check if the NFT metadata is properly set and the state is updated
  let ?retrievedMetadata = icrc7.get_nft(token_id) else return assert(false);
  assert(
    // Ensure that the retrieved metadata matches the expected metadata
    CandyTypesLib.eqShared(metadata, CandyTypesLib.shareCandy(retrievedMetadata.meta))
  );
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);


testsys<system>("Update immutable and non-immutable NFT properties", func<system>() {
  //Arrange: Set up the ICRC7 instance and required parameters
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  let token_id = 12;  // Assuming a token ID for testing
  let initialMetadata = #Class([
    {name="test"; value=#Text("initialTestValue"); immutable = false},
    {name="test3"; value=#Text("immutableTestValue"); immutable = true}
  ]);  // Define the initial metadata for testing


  let targetMetadata = #Class([
    {name="test"; value=#Text("updatedTestValue"); immutable = false},
    {name="test3"; value=#Text("immutableTestValue"); immutable = true}
  ]);  // Define the initial metadata for testing

  let updateImmutable = {name="test"; mode=#Set(#Text("updatedTestValue"))};  // Define an update for non-immutable property
  let updateNonImmutable = {name="test3"; mode=#Set(#Text("updatedImmutableTestValue"));};  // Define an update for immutable property
  
  let mintedNftMetadata = initialMetadata;
  let nft = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=token_id;override=true;metadata=mintedNftMetadata;}],false);

  // Act and Assert: Attempt to update the immutable and non-immutable properties
  let #ok(resultNonImmutableUpdate) = icrc7.update_nfts<system>(testOwner, [{memo=null; created_at_time=null; token_id=token_id;updates=[updateImmutable];}]) else return assert(false);

  D.print("resultNonImmutableUpdate" # debug_show(resultNonImmutableUpdate));

  let resultImmutableUpdateCall = icrc7.update_nfts<system>(testOwner, [{memo=null; created_at_time=null; token_id=token_id;updates=[updateNonImmutable];}]);

  D.print("resultImmutableUpdateCall" # debug_show(resultImmutableUpdateCall));

  let #ok(resultImmutableUpdate) = icrc7.update_nfts<system>(testOwner, [{memo=null; created_at_time=null; token_id=token_id;updates=[updateNonImmutable];}]) else return assert(false);

  let #Err(#GenericError(anerror)) = resultImmutableUpdate[0] else return assert(false);

  assert(anerror.error_code == 875);

  D.print("resultImmutableUpdate" # debug_show(resultImmutableUpdate));

  //assert(
    // Ensure the update for the non-immutable property succeeds and returns true
  //  resultImmutableUpdate[0] == false//, "Update for non-immutable property should succeed"
  //);

  // Assert: Check if the updated metadata matches the expectation
  let ?retrievedMetadata = icrc7.get_nft(token_id) else return assert(false);
  assert(
    // Ensure the updated metadata matches the non-immutable update
    CandyTypesLib.eq(CandyTypesLib.unshare(targetMetadata), retrievedMetadata.meta)//,
    //"Updated non-immutable property matches the expectations"
  );
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);


testsys<system>("Attempt to transfer with duplicate or empty token ID arrays", func<system>() {
  // Arrange: Set up the ICRC7 instance and approval parameters
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  let tokenOwner = {owner = testOwner; subaccount=null};  // Replace with appropriate owner principal
  let tokenCanister = {owner = testCanister; subaccount=null};  // Replace with appropriate owner principal
  let tokenIdsWithDuplicates = [1, 2, 3, 4, 5, 5];  // Token ID array with duplicate items

  let token_ids = [1, 2, 3, 4, 5, 6, 7, 8 ,9, 10]; // Assuming tokens with IDs 1, 2, and 3 have been minted with known metadata
  
  let metadata1 = baseNFT;
  for(thisItem in token_ids.vals()){

    let #ok(metadata) = Properties.updatePropertiesShared(CandyConv.candySharedToProperties(baseNFT), [{
      name = "url";
      mode = #Set(#Text("https://example.com/" # Nat.toText(thisItem)))
    }]) else return assert(false);

    let nft = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner = ?testOwnerAccount;token_id=thisItem;override=true;metadata=#Class(metadata);}],false);

  };


  let emptyTokenIds = [];  // Empty token ID array
  let tkids = Vec.new<ICRC7.TransferArg>();
  for(i in tokenIdsWithDuplicates.vals()){
    Vec.add<ICRC7.TransferArg>(tkids, {
      memo = ?Text.encodeUtf8("Approval memo");
      expires_at = ?(test_time + one_minute): ?Nat64;  // Replace with appropriate expiry timestamp
      created_at_time = ?test_time : ?Nat64;  // Replace with appropriate creation timestamp
      from_subaccount = tokenOwner.subaccount;
      to = tokenCanister;
      token_id = i
    });
  };
  let transferArgs = Vec.toArray(tkids);

  let tkids2 = Vec.new<ICRC7.TransferArg>();
  for(i in tokenIdsWithDuplicates.vals()){
    Vec.add<ICRC7.TransferArg>(tkids2, {
      memo = ?Text.encodeUtf8("Approval memo");
      expires_at = ?(test_time + one_minute): ?Nat64;  // Replace with appropriate expiry timestamp
      created_at_time = ?test_time : ?Nat64;  // Replace with appropriate creation timestamp
      from_subaccount = tokenOwner.subaccount;
      to = tokenCanister;
      token_id = i
    } : ICRC7.TransferArg);
  };

  let transferArgs2 = Vec.toArray(tkids2);

  // Act: Attempt approval requests with duplicate and empty token ID arrays
  let #ok(result) = icrc7.transfer_tokens(testOwner, transferArgs);
  let ?#Err(approvalResponsesWithDuplicates) = result[5]  else {
    D.print("approvalResponsesWithDuplicates" # debug_show(result));
    return assert(false);
  }; 

  let #ok(result2) = icrc7.transfer_tokens(testOwner, transferArgs2);
  let ?#Err(approvalResponsesWithDuplicates2) = result2[5]  else {
    D.print("approvalResponsesWithDuplicates2" # debug_show(result));
    return assert(false);
  }; 


 
  /* let approvalResponsesWithDuplicates = icrc7.approve_transfers(base_environment, tokenOwner, tokenIdsWithDuplicates, approvalInfo) else return assert(false);
  let approvalResponsesEmpty = icrc7.approve_transfers(base_environment, tokenOwner, emptyTokenIds, approvalInfo) else return assert(false); */

  D.print("resultImmutableUpdate" # debug_show(approvalResponsesWithDuplicates));

});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

testsys<system>("Test DeDupe on transfer", func<system>() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  
  // Arrange: Set up the necessary variables for the transfer
  let tokenOwner = testOwner; // Replace with appropriate owner principal
  let fromAccount = {owner = tokenOwner; subaccount = null}; // Replace with the appropriate owner's account
  let toAccount = {owner = testCanister; subaccount = null}; // Place the recipient's account
  
  let token_id = 1;  // Assuming token with ID 1 exists
  let metadata = baseNFT;
  D.print("about to set" # debug_show(metadata));
  let nft = icrc7.set_nfts<system>(testOwner, [{memo=null;created_at_time=null;owner=?testOwnerAccount;token_id=token_id;override=true;metadata=metadata;}],false);
  
  // Act: Transfer the token from the `fromAccount` to the `toAccount`
  let transferArgs = [{
    from_subaccount = fromAccount.subaccount;
    to = toAccount;
    token_id = token_id;
    memo = ?Text.encodeUtf8("Transfer memo");
    created_at_time = ?test_time;  // Replace with the current timestamp
  }];

  D.print("about to transfer" # debug_show(transferArgs));

  let #ok(transferResults) = icrc7.transfer_tokens(tokenOwner, transferArgs) else return assert(false);

  D.print("transfer" # debug_show(transferResults));

  let transferArgs2 = [{
    from_subaccount = toAccount.subaccount;
    to = fromAccount;
    token_id = token_id;
    memo = ?Text.encodeUtf8("Transfer memo");
    created_at_time = ?test_time;  // Replace with the current timestamp
  }];

  //send back
  let #ok(transferResults2) = icrc7.transfer_tokens(toAccount.owner, transferArgs2) else return assert(false);

  D.print("transfer back" # debug_show(transferResults2));


  //replay back
  let #ok(transferResults3) = icrc7.transfer_tokens(tokenOwner, transferArgs) else return assert(false);

  D.print("duplicate " # debug_show(transferResults3));


  // Assert: Check if the token is successfully transferred
  assert(
    transferResults.size() == 1
  ); // "A single token transfer result is received"

  // Assert: Check if the token is successfully transferred
  assert(
    transferResults2.size() == 1
  ); // "A single token transfer result is received"

  let ?errfound = transferResults3[0];

  assert(
    (switch(errfound) {
      case (#Err(val)){
        switch(val){
          case(#Duplicate(val)) val.duplicate_of;
          case(_) return assert(false);
        };
      };
      case (_) return assert(false);
    }) >= 0
  ); // "Transfer result duplicate fails"

  // Query for the owner of the token after transfer
  let ?ownerResponse = icrc7.get_token_owner(token_id);


  assert(ownerResponse.owner == fromAccount.owner);
  assert(ownerResponse.subaccount == fromAccount.subaccount);
    

  //advance time more than two minutes
    ignore set_time(get_time64() + (1_000_000_000 * 60 * 2) + 1);

    let #ok(transferResults4) = icrc7.transfer_tokens<system>(tokenOwner, [{transferArgs[0] with created_at_time = ?get_time64()}]) else return assert(false);

    D.print("unduped " # debug_show(transferResults4));

    // Assert: Check if the token is successfully transferred
  assert(
    transferResults4.size() == 1
  ); // "A single token transfer result is received"

  let ?ownerResponse2 = icrc7.get_token_owner(token_id);


  assert(ownerResponse2.owner == toAccount.owner);
  assert(ownerResponse2.subaccount == toAccount.subaccount);

   
});