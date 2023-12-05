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
import {test} "mo:test";

let testOwner = Principal.fromText("exoh6-2xmej-lux3z-phpkn-2i3sb-cvzfx-totbl-nzfcy-fxi7s-xiutq-mae");
let testCanister = Principal.fromText("p75el-ys2la-2xa6n-unek2-gtnwo-7zklx-25vdp-uepyz-qhdg7-pt2fi-bqe");

let spender1 : ICRC7.Account = {owner = Principal.fromText("2dzql-vc5j3-p5nyh-vidom-fhtyt-edvv6-bqewt-j63fn-ovwug-h67hb-yqe"); subaccount = ?Blob.fromArray([1,2])};
let spender2 : ICRC7.Account = {owner = Principal.fromText("32fn4-qqaaa-aaaak-ad65a-cai"); subaccount = ?Blob.fromArray([3,4])};
let spender3 : ICRC7.Account = {owner = Principal.fromText("zfcdd-tqaaa-aaaaq-aaaga-cai"); subaccount = ?Blob.fromArray([5,6])};
let spender4 : ICRC7.Account = {owner = Principal.fromText("x33ed-h457x-bsgyx-oqxqf-6pzwv-wkhzr-rm2j3-npodi-purzm-n66cg-gae"); subaccount = ?Blob.fromArray([7,8])};
let spender5 : ICRC7.Account = {owner = Principal.fromText("dtnbn-kyaaa-aaaak-aeigq-cai"); subaccount = ?Blob.fromArray([9,10])};

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
  allow_transfers = null;
  burn_account = null;
  deployer = testOwner;
};

let baseNFT : CandyTypesLib.CandyShared = #Class([
  {immutable=false; name=ICRC7.token_property_owner_account; value = #Map([(ICRC7.token_property_owner_principal,#Blob(Principal.toBlob(testOwner)))]);},
  {immutable=false; name="url"; value = #Text("https://example.com/1");}
]);

let baseNFTWithSubAccount : CandyTypesLib.CandyShared = #Class([
  {immutable=false; name=ICRC7.token_property_owner_account; value = #Map(
    
    [(ICRC7.token_property_owner_principal, #Blob(Principal.toBlob(testOwner))),
     (ICRC7.token_property_owner_subaccount, #Blob(Blob.fromArray([1])))
    ]
    );},
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


test("Query for token metadata by ID should return correct token metadata", func() {

  D.print("starting token metatdata test");
  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  // For this test to succeed, a token with `token_id` must have been minted,
  // and its metadata should be set in the state before querying.
  // This represents the 'Arrange' part of the test (Arrange-Act-Assert)
  let token_id = 1; // Assuming token ID `1` has been minted with known metadata
  let metadata = baseNFT;
  D.print("about to set" # debug_show(metadata));
  let nft = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=token_id;override=true;metadata=metadata;}]});

  D.print("nft has been set" # debug_show(nft));
  
  let ?found_nft = icrc7.get_token_info(token_id) else return assert(false);

  D.print("have an nft" # debug_show(found_nft));
  // Assert: The received metadata should match the expected metadata
  assert(CandyTypesLib.eq(CandyTypesLib.unshare(metadata), found_nft));
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

test("Query for batched token metadata by a list of IDs should return correct metadata for all queried tokens", func() {

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
  
  
  let nft1 = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=1;override=true;metadata=metadata1;}]});
  let nft2 = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=2;override=true;metadata=#Class(metadata2)}]});
  let nft3 = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=3;override=true;metadata=#Class(metadata3)}]});

  let found_nfts = icrc7.get_token_infos(token_ids);

  // Assert: The received metadata for all queried tokens should match the expected metadata
  assert(CandyTypesLib.eq(CandyTypesLib.unshare(metadata1), Opt.get<ICRC7.NFT>(Opt.get<(Nat, ?ICRC7.NFT)>(Array.find<(Nat,?ICRC7.NFT)>(found_nfts, func(x : (Nat,?ICRC7.NFT)){x.0 == 1;}), (0, ?#Nat(0))).1, #Nat(0))));

  let baseNFT2 : CandyTypesLib.Candy = CandyTypesLib.unshare(#Class(metadata2));
  assert(CandyTypesLib.eq(
    baseNFT2 , 
    Opt.get<ICRC7.NFT>(
      Opt.get<(Nat, ?ICRC7.NFT)>(
        Array.find<(Nat,?ICRC7.NFT)>(found_nfts, func(x : (Nat,?ICRC7.NFT)){x.0 == 2;}), (0, ?#Nat(0))).1, #Nat(0)) : CandyTypesLib.Candy));
  let baseNFT3 : CandyTypesLib.Candy = CandyTypesLib.unshare(#Class(metadata3));

  assert(CandyTypesLib.eq(baseNFT3, Opt.get<ICRC7.NFT>(Opt.get<(Nat, ?ICRC7.NFT)>(Array.find<(Nat,?ICRC7.NFT)>(found_nfts, func(x : (Nat,?ICRC7.NFT)){x.0 == 3;}), (0, ?#Nat(0))).1, #Nat(0))));
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

test("Query for the owner of a specific token ID should return correct owner information", func() {
  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  // For this test to succeed, a token with `token_id` must have been minted,
  // and its ownership information should be set in the state before querying.
  // This represents the 'Arrange' part of the test (Arrange-Act-Assert)
  let token_id = 1; // Assuming token ID `1` has been minted with known ownership information
  let metadata = baseNFT;
  let nft = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=token_id;override=true;metadata=metadata;}]});
  
  
  // Act: Query the owner information for the specified token ID
  let ?ownerResponse = icrc7.get_token_owner(token_id);
  D.print(debug_show(ownerResponse));

  let ?ownerAccount = ownerResponse.account else return assert(false);

  // Assert: The received owner information should match the expected owner information
  assert(ICRC7.account_eq(ownerAccount, {owner = testOwner; subaccount = null}));

  //with sub account
  let token_id2 = 2; // Assuming token ID `1` has been minted with known ownership information
  let metadata2 = baseNFTWithSubAccount;
  let nft2 = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=token_id2;override=true;metadata=metadata2;}]});
  
  
  // Act: Query the owner information for the specified token ID
  let ?ownerResponse2 = icrc7.get_token_owner(token_id2);
  D.print("have owner 2" # debug_show(ownerResponse2));

  let ?ownerAccount2 = ownerResponse2.account else return assert(false);
  D.print("have owner target" # debug_show({owner = testOwner; subaccount = ?Blob.fromArray([1])}));
  // Assert: The received owner information should match the expected owner information
  assert(ICRC7.account_eq(ownerAccount2, {owner = testOwner; subaccount = ?Blob.fromArray([1])}));
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

test("Query for token ownership metadata directly from token metadata", func() {
  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  // Sample token ID for testing
  let token_id = 1; // Assuming token ID `1` has been minted with known ownership information
  let metadata = baseNFTWithSubAccount;
  let nft = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=token_id; override=true;metadata=metadata;}]});

  // Mockup metadata fetch from the ICRC7 contract
  let ?fetched_metadata = icrc7.get_token_info(token_id) else return assert(false);

  switch(fetched_metadata){
    case(#Class(val)){
      let ?account = Map.get(val, Map.thash, ICRC7.token_property_owner_account) else return assert(false);
      switch(account.value){
        case(#Map(details)){
          let ?owner = Map.get(details, Map.thash, ICRC7.token_property_owner_principal) else return assert(false);
          let ?subaccount = Map.get(details, Map.thash, ICRC7.token_property_owner_subaccount) else return assert(false);
          
          assert(CandyTypesLib.eq(owner, #Blob(Principal.toBlob(testOwner))));
          assert(CandyTypesLib.eq(subaccount, #Blob(Blob.fromArray([1]))));
        };
        case(_){
          return assert(false);
        };
      };
    };
    case(_){
      return assert(false);
    };
  }
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

test("Query for a list of token IDs owned by an account should return correct set of token IDs", func() {
  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  // For this test to succeed, tokens must have been minted and assigned to the test owner account.
  // This represents the 'Arrange' part of the test (Arrange-Act-Assert)
  let token_ids = [1, 2, 3]; // Assuming tokens with IDs 1, 2, and 3 have been minted with known metadata
  let metadata1 = baseNFT;
  let #ok(metadata2) = Properties.updatePropertiesShared(CandyConv.candySharedToProperties(baseNFT), [{
    name = "url";
    mode = #Set(#Text("https://example.com/2"))
  },
  {
    name = ICRC7.token_property_owner_account;
    mode = #Set(#Map([(ICRC7.token_property_owner_principal,#Blob(Principal.toBlob(testCanister)))]))
  }]) else return assert(false);

  let #ok(metadata3) = Properties.updatePropertiesShared(CandyConv.candySharedToProperties(baseNFT), [{
    name = "url";
    mode = #Set(#Text("https://example.com/3"))
  }]) else return assert(false);
  
  
  let nft1 = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=1;override=true;metadata=metadata1;}]});
  let nft2 = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=2;override=true;metadata=#Class(metadata2)}]});
  let nft3 = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=3;override=true;metadata=#Class(metadata3)}]});

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


test("Paginate through the list of tokens and receive the correct page of tokens", func() {
  // The ICRC7 class and base environment are set up from the provided framework
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  let token_ids = [1, 2, 3, 4, 5, 6, 7, 8 ,9, 10]; // Assuming tokens with IDs 1, 2, and 3 have been minted with known metadata
  let metadata1 = baseNFT;
  for(thisItem in token_ids.vals()){

    let #ok(metadata) = Properties.updatePropertiesShared(CandyConv.candySharedToProperties(baseNFT), [{
      name = "url";
      mode = #Set(#Text("https://example.com/" # Nat.toText(thisItem)))
    }]) else return assert(false);

    let nft = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=thisItem;override=true;metadata=#Class(metadata);}]});

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

test("Paginate through the list of tokens owned by an account", func() {
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
    {
      name = ICRC7.token_property_owner_account;
      mode = #Set(#Map([(ICRC7.token_property_owner_principal,#Blob(Principal.toBlob(
        if(thisItem < 6) testOwner
        else testCanister)))]))
    }]) else return assert(false);

    let nft = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=thisItem;override=true;metadata=#Class(metadata);}]});

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


test("Transfer a token to another account", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  
  // Arrange: Set up the necessary variables for the transfer
  let tokenOwner = testOwner; // Replace with appropriate owner principal
  let fromAccount = {owner = tokenOwner; subaccount = null}; // Replace with the appropriate owner's account
  let toAccount = {owner = testCanister; subaccount = null}; // Place the recipient's account
  
  let token_id = 1;  // Assuming token with ID 1 exists
  let metadata = baseNFT;
  D.print("about to set" # debug_show(metadata));
  let nft = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=token_id;override=true;metadata=metadata;}]});
  
  // Act: Transfer the token from the `fromAccount` to the `toAccount`
  let transferArgs = {
    subaccount = fromAccount.subaccount;
    to = toAccount;
    token_ids = [token_id];
    memo = ?Text.encodeUtf8("Transfer memo");
    created_at_time = ?test_time;  // Replace with the current timestamp
  };

  D.print("about to transfer" # debug_show(transferArgs));

  let #ok(#Ok(transferResults)) = icrc7.transfer(tokenOwner, transferArgs) else return assert(false);

  D.print("transfer" # debug_show(transferResults));

  // Assert: Check if the token is successfully transferred
  assert(
    transferResults.size() == 1
  ); // "A single token transfer result is received"

  assert(
    (switch(transferResults[0].transfer_result) {
      case (#Ok(val)) val;
      case (_) return assert(false);
    }) >= 0
  ); // "Transfer result for the token with ID 1"

  // Query for the owner of the token after transfer
  let ?ownerResponse = icrc7.get_token_owner(token_id);

    (switch(ownerResponse.account) {
      case (?val) {
        assert(val.owner == toAccount.owner);
        assert(val.subaccount == toAccount.subaccount);
      };
      case (_) return assert(false);
    });
    
  
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

test("Reject Transfer Attempt by Unauthorized User", func() {
  // Arrange: Set up the ICRC7 instance, current test environment, and required variables
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);

  let token_id = 1;  // Assuming token with ID 1 exists
  let metadata = baseNFT;
  D.print("about to set" # debug_show(metadata));
  let nft = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=token_id;override=true;metadata=metadata;}]});


  let unauthorizedOwner = spender1;  // Replace with an unauthorized owner principal
  let unauthorizedTransferArgs = {
    subaccount = unauthorizedOwner.subaccount;
    to = spender2;
    memo = ?Text.encodeUtf8("Unauthorized transfer attempt");
    token_ids = [1];  // Replace with appropriate token ID for a token that the unauthorized owner owns
    created_at_time = ?init_time : ?Nat64;  // Replace with appropriate creation timestamp
  };

  // Act: Attempt to transfer a token by an unauthorized user
  let #ok(#Ok(transferResponses)) = icrc7.transfer(unauthorizedOwner.owner, unauthorizedTransferArgs) else return assert(false);

  // Assert: Check if the transfer attempt is rejected
  assert(
    transferResponses.size() == 1
  ); //"Exactly one transfer response"
  assert(
    (switch(transferResponses[0].transfer_result) {
      case (#Err(err)) true;
      case (#Ok(val)) false;
    })
  ); //"Transfer attempt is rejected"
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);


test("Update the metadata for the ledger", func() {
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

test("Set metadata for a new NFT token", func() {
  // Arrange: Set up the ICRC7 instance and required parameters
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  let token_id = 11;  // Assuming a new token ID
  let metadata = baseNFT;  // Define the metadata for the new NFT

  // Act: Set the metadata for the new NFT token
  let nftResult = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=token_id;override=true;metadata=metadata;}]});

  // Assert: Check if the NFT metadata is properly set and the state is updated
  let ?retrievedMetadata = icrc7.get_token_info(token_id) else return assert(false);
  assert(
    // Ensure that the retrieved metadata matches the expected metadata
    CandyTypesLib.eqShared(metadata, CandyTypesLib.shareCandy(retrievedMetadata))
  );
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);


test("Update immutable and non-immutable NFT properties", func() {
  //Arrange: Set up the ICRC7 instance and required parameters
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  let token_id = 12;  // Assuming a token ID for testing
  let initialMetadata = #Class([
    {immutable=false; name=ICRC7.token_property_owner_account; value = #Map([(ICRC7.token_property_owner_principal,#Blob(Principal.toBlob(testOwner)))]);},
    {name="test"; value=#Text("initialTestValue"); immutable = false},
    {name="test3"; value=#Text("immutableTestValue"); immutable = true}
  ]);  // Define the initial metadata for testing


  let targetMetadata = #Class([
    {immutable=false; name=ICRC7.token_property_owner_account; value = #Map([(ICRC7.token_property_owner_principal,#Blob(Principal.toBlob(testOwner)))]);},
    {name="test"; value=#Text("updatedTestValue"); immutable = false},
    {name="test3"; value=#Text("immutableTestValue"); immutable = true}
  ]);  // Define the initial metadata for testing

  let updateImmutable = {name="test"; mode=#Set(#Text("updatedTestValue"))};  // Define an update for non-immutable property
  let updateNonImmutable = {name="test3"; mode=#Set(#Text("updatedImmutableTestValue"));};  // Define an update for immutable property
  
  let mintedNftMetadata = initialMetadata;
  let nft = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=token_id;override=true;metadata=mintedNftMetadata;}]});

  // Act and Assert: Attempt to update the immutable and non-immutable properties
  let #ok(#Ok(resultNonImmutableUpdate)) = icrc7.update_nfts(testOwner, {memo=null; created_at_time=null; tokens=[{token_id=token_id;updates=[updateImmutable];}]}) else return assert(false);

  D.print("resultNonImmutableUpdate" # debug_show(resultNonImmutableUpdate));

  let resultImmutableUpdateCall = icrc7.update_nfts(testOwner, {memo=null; created_at_time=null; tokens=[{token_id=token_id;updates=[updateNonImmutable];}]});

  D.print("resultImmutableUpdateCall" # debug_show(resultImmutableUpdateCall));

  let #ok(#Ok(resultImmutableUpdate)) = icrc7.update_nfts(testOwner, {memo=null; created_at_time=null; tokens=[{token_id=token_id;updates=[updateNonImmutable];}]}) else return assert(false);

  let #Err(#GenericError(err)) = resultImmutableUpdate[0].result;

  assert(err.error_code == 875);

  D.print("resultImmutableUpdate" # debug_show(resultImmutableUpdate));

  //assert(
    // Ensure the update for the non-immutable property succeeds and returns true
  //  resultImmutableUpdate[0] == false//, "Update for non-immutable property should succeed"
  //);

  // Assert: Check if the updated metadata matches the expectation
  let ?retrievedMetadata = icrc7.get_token_info(token_id) else return assert(false);
  assert(
    // Ensure the updated metadata matches the non-immutable update
    CandyTypesLib.eq(CandyTypesLib.unshare(targetMetadata), retrievedMetadata)//,
    //"Updated non-immutable property matches the expectations"
  );
});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);


test("Attempt to transfer with duplicate or empty token ID arrays", func() {
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
    },
    {
      name = ICRC7.token_property_owner_account;
      mode = #Set(#Map([(ICRC7.token_property_owner_principal,#Blob(Principal.toBlob(
        if(thisItem < 6) testOwner
        else testCanister)))]))
    }]) else return assert(false);

    let nft = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=thisItem;override=true;metadata=#Class(metadata);}]});

  };


  let emptyTokenIds = [];  // Empty token ID array
  
  let transferArgs = {
    memo = ?Text.encodeUtf8("Approval memo");
    expires_at = ?(test_time + one_minute): ?Nat64;  // Replace with appropriate expiry timestamp
    created_at_time = ?test_time : ?Nat64;  // Replace with appropriate creation timestamp
    subaccount = tokenOwner.subaccount;
    to = tokenCanister;
    token_ids = tokenIdsWithDuplicates
  };

  let transferArgs2 = {
    memo = ?Text.encodeUtf8("Approval memo");
    expires_at = ?(test_time + one_minute): ?Nat64;  // Replace with appropriate expiry timestamp
    created_at_time = ?test_time : ?Nat64;  // Replace with appropriate creation timestamp
    subaccount = tokenOwner.subaccount;
    to = tokenCanister;
    token_ids = emptyTokenIds
  };

  // Act: Attempt approval requests with duplicate and empty token ID arrays
  let #err(approvalResponsesWithDuplicates) = icrc7.transfer(testOwner, transferArgs) else return assert(false);
  let #err(approvalResponsesEmpty) = icrc7.transfer(testOwner, transferArgs2) else return assert(false);
 
  /* let approvalResponsesWithDuplicates = icrc7.approve_transfers(base_environment, tokenOwner, tokenIdsWithDuplicates, approvalInfo) else return assert(false);
  let approvalResponsesEmpty = icrc7.approve_transfers(base_environment, tokenOwner, emptyTokenIds, approvalInfo) else return assert(false); */

  D.print("resultImmutableUpdate" # debug_show(approvalResponsesWithDuplicates));

});

icrc7_migration_state := ICRC7.init(ICRC7.initialState(), #v0_1_0(#id), ?baseCollection, testOwner);

test("Test DeDupe on transfer", func() {
  let icrc7 = ICRC7.ICRC7(?icrc7_migration_state, testCanister, base_environment);
  
  // Arrange: Set up the necessary variables for the transfer
  let tokenOwner = testOwner; // Replace with appropriate owner principal
  let fromAccount = {owner = tokenOwner; subaccount = null}; // Replace with the appropriate owner's account
  let toAccount = {owner = testCanister; subaccount = null}; // Place the recipient's account
  
  let token_id = 1;  // Assuming token with ID 1 exists
  let metadata = baseNFT;
  D.print("about to set" # debug_show(metadata));
  let nft = icrc7.set_nfts(testOwner, {memo=null;created_at_time=null;tokens=[{token_id=token_id;override=true;metadata=metadata;}]});
  
  // Act: Transfer the token from the `fromAccount` to the `toAccount`
  let transferArgs = {
    subaccount = fromAccount.subaccount;
    to = toAccount;
    token_ids = [token_id];
    memo = ?Text.encodeUtf8("Transfer memo");
    created_at_time = ?test_time;  // Replace with the current timestamp
  };

  D.print("about to transfer" # debug_show(transferArgs));

  let #ok(#Ok(transferResults)) = icrc7.transfer(tokenOwner, transferArgs) else return assert(false);

  D.print("transfer" # debug_show(transferResults));

  let transferArgs2 = {
    subaccount = toAccount.subaccount;
    to = fromAccount;
    token_ids = [token_id];
    memo = ?Text.encodeUtf8("Transfer memo");
    created_at_time = ?test_time;  // Replace with the current timestamp
  };

  //send back
  let #ok(#Ok(transferResults2)) = icrc7.transfer(toAccount.owner, transferArgs2) else return assert(false);

  D.print("transfer back" # debug_show(transferResults2));


  //replay back
  let #ok(#Ok(transferResults3)) = icrc7.transfer(tokenOwner, transferArgs) else return assert(false);

  D.print("duplicate " # debug_show(transferResults3));


  // Assert: Check if the token is successfully transferred
  assert(
    transferResults.size() == 1
  ); // "A single token transfer result is received"

  // Assert: Check if the token is successfully transferred
  assert(
    transferResults2.size() == 1
  ); // "A single token transfer result is received"

  assert(
    (switch(transferResults3[0].transfer_result) {
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

    (switch(ownerResponse.account) {
      case (?val) {
        assert(val.owner == fromAccount.owner);
        assert(val.subaccount == fromAccount.subaccount);
      };
      case (_) return assert(false);
    });

  //advance time more than two minutes
    ignore set_time(get_time64() + (1_000_000_000 * 60 * 2) + 1);

    let #ok(#Ok(transferResults4)) = icrc7.transfer(tokenOwner, {transferArgs with created_at_time = ?get_time64()}) else return assert(false);

    D.print("unduped " # debug_show(transferResults4));

    // Assert: Check if the token is successfully transferred
  assert(
    transferResults4.size() == 1
  ); // "A single token transfer result is received"

  let ?ownerResponse2 = icrc7.get_token_owner(token_id);

    (switch(ownerResponse2.account) {
      case (?val) {
        assert(val.owner == toAccount.owner);
        assert(val.subaccount == toAccount.subaccount);
      };
      case (_) return assert(false);
    });

  
});