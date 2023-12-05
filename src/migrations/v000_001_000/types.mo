
// please do not import any types from your project outside migrations folder here
// it can lead to bugs when you change those types later, because migration types should not be changed
// you should also avoid importing these types anywhere in your project directly from here
// use MigrationTypes.Current property instead

import MapLib "mo:map9/Map";
import SetLib "mo:map9/Set";
import CandyTypesLib "mo:candy_0_3_0/types";
import Array "mo:base/Array";
import VecLib "mo:vector";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import D "mo:base/Debug";
import Order "mo:base/Order";
import Result "mo:base/Result";
import Text "mo:base/Text";

module {

  public let Map = MapLib;
  public let Set = SetLib;
  public let Vec = VecLib;
  public let CandyTypes = CandyTypesLib;

  /// As described by ICRC3
  public type Value = { 
    #Blob : Blob; 
    #Text : Text; 
    #Nat : Nat;
    #Int : Int;
    #Array : [Value]; 
    #Map : [(Text, Value)]; 
  };

  public type Transaction = Value;

  // Account Types
	public type Subaccount = Blob;

  /// As descrived by ICRC1
  public type Account = {
    owner: Principal;
    subaccount:  ?Subaccount;
  };

  /// default 10000
  public let default_max_update_batch_size = 10000;

  /// default 10000
  public let default_max_query_batch_size = 10000;

  /// default 10000
  public let default_default_take_value = 10000;

  /// default 10000
  public let default_max_take_value = 10000;

  /// default 384
  public let default_max_memo_size = 384;

  /// default 2 Minutes
  public let default_permitted_drift = 120000000000; //1_000_000_000 * 60 * 2; //two Minutes

  /// default true
  public let default_allow_transfers = true; 

  //responses

  //todo: outstanding fix
  public type OwnerOfResponse = {
    token_id: Nat;
    account: ?Account;
  };

  public type OwnerOfResponses = [OwnerOfResponse];

  public type TokenID = Nat;

  public type SupportedStandards = [{ name : Text; url : Text }];

  public type LedgerInfo =  {
    var symbol  : ?Text;
    var name    : ?Text;
    var description : ?Text;
    var logo : ?Text;
    var supply_cap: ?Nat;
    var max_query_batch_size : Nat;
    var max_update_batch_size : Nat;
    var default_take_value : Nat;
    var max_take_value: Nat;
    var max_memo_size : Nat;
    var permitted_drift : Nat;
    var allow_transfers : Bool;
    var burn_account : ?Account
  };

  public type LedgerInfoShared =  {
    symbol  : ?Text;
    name    : ?Text;
    description : ?Text;
    logo : ?Text;
    supply_cap: ?Nat;
    max_query_batch_size : Nat;
    max_update_batch_size : Nat;
    default_take_value : Nat;
    max_take_value: Nat;
    max_memo_size : Nat;
    permitted_drift: Nat;
    allow_transfers: Bool;
    burn_account: ?Account
  };

  public type NFT = CandyTypes.Candy;
  public type NFTInput = CandyTypes.CandyShared;
  public type NFTShared = Value;
  public type NFTMap = [(Text, Value)];

  public type Error = {
    error_code : Nat;
    message : Text;
  };

  public type TransferArgs = {
    subaccount : ?Blob;
    to : Account;
    token_ids : [Nat];
    // type: leave open for now
    memo : ?Blob;
    created_at_time : ?Nat64;
  };

  public type TransferNotification = {
    from : Account;
    to : Account;
    token_id : Nat;
    memo : ?Blob;
    created_at_time : ?Nat64;
  };

  public type TransferBatchError = {
    #TooOld;
    #InvalidRecipient;
    #CreatedInFuture : { ledger_time: Nat64 };
    #GenericError : { error_code : Nat; message : Text };
  };

  public type TransferResponseItem = {
    token_id : Nat;
    transfer_result :{
      #Ok: Nat;
      #Err: TransferError
    };
  };

  public type TransferResponse = {
    #Ok :[TransferResponseItem];
    #Err : TransferBatchError;
  };

  public type TransferError = {
    #NonExistingTokenId;
    #Unauthorized;
    #Duplicate : { duplicate_of : Nat };
    #GenericError : { 
      error_code : Nat; 
      message : Text 
    };
  };

  public type UpdateLedgerInfoRequest = {
    #Symbol: ?Text;
    #Name : ?Text;
    #Description: ?Text;
    #Logo: ?Text;
    #SupplyCap: ?Nat;
    #MaxQueryBatchSize : Nat;
    #MaxUpdateBatchSize : Nat;
    #DefaultTakeValue : Nat;
    #MaxTakeValue : Nat;
    #MaxMemoSize : Nat;
    #PermittedDrift : Nat;
    #AllowTransfers : Bool;
    #UpdateOwner : Principal;
    #BurnAccount : ?Account
  };

  public type SetNFTRequest = {
    memo: ?Blob;
    created_at_time : ?Nat64;
    tokens : [SetNFTItemRequest];
  };

  public type MintNotification = {
    memo: ?Blob;
    from: ?Account;
    to: Account;
    created_at_time : ?Nat64;
    hash : Blob;
    token_id : Nat;
    new_token : Bool;
  };

  public type SetNFTItemRequest = {
    token_id: Nat;
    metadata: NFTInput;
    override: Bool;
  };

  public type SetNFTBatchResponse = {
    #Ok: [SetNFTItemResponse];
    #Err: SetNFTBatchError;
  };

  public type SetNFTItemResponse = {
    token_id: Nat;
    result: SetNFTResult;
  };

  public type SetNFTResult =  {
    #Ok: Nat;
    #Err: SetNFTError;
    #GenericError : { error_code : Nat; message : Text };
  };

  public type SetNFTError = {
    #NonExistingTokenId;
    #TokenExists;
    #GenericError : { error_code : Nat; message : Text };
  
  };

  public type SetNFTBatchError = {
    #TooOld;
    #CreatedInFuture : { ledger_time: Nat64 };
    #GenericError : { error_code : Nat; message : Text };
  };

  public type BurnNFTRequest = {
    memo: ?Blob;
    created_at_time : ?Nat64;
    tokens : [Nat];
  };

  public type BurnNotification = {
    memo: ?Blob;
    from: Account;
    created_at_time : ?Nat64;
    token_id : Nat;
  };

  public type BurnNFTBatchResponse = {
    #Ok: [BurnNFTItemResponse];
    #Err: BurnNFTBatchError;
  };

  public type BurnNFTItemResponse = {
    token_id: Nat;
    result: BurnNFTResult;
  };

  public type BurnNFTResult =  {
    #Ok: Nat;
    #Err: BurnNFTError;
  };

  public type BurnNFTError = {
    #NonExistingTokenId;
    #InvalidBurn;
    #GenericError : { error_code : Nat; message : Text };
  };

  public type BurnNFTBatchError = {
    #TooOld;
    #CreatedInFuture : { ledger_time: Nat64 };
    #Unauthorized;
    #GenericError : { error_code : Nat; message : Text };
  };

  public type UpdateNFTRequest = {
    memo: ?Blob;
    created_at_time : ?Nat64;
    tokens : [UpdateNFTItemRequest];
  };

  public type UpdateNFTItemRequest = {
    token_id: Nat;
    updates: [CandyTypesLib.Update]
  };

  public type UpdateNFTBatchResponse = {
    #Ok: [UpdateNFTItemResponse];
    #Err: UpdateNFTBatchError;
  };

  public type UpdateNFTItemResponse = {
    token_id: Nat;
    result: UpdateNFTResult;
  };

  public type UpdateNFTResult =  {
    #Ok: Nat;
    #Err: UpdateNFTError;
  };

  public type UpdateNFTError = {
    #NonExistingTokenId;
    #GenericError : { error_code : Nat; message : Text };
  };

  public type UpdateNFTBatchError = {
    #TooOld;
    #CreatedInFuture : { ledger_time: Nat64 };
    #GenericError : { error_code : Nat; message : Text };
  };

  public func account_hash32(a : Account) : Nat32{
    var accumulator = Map.phash.0(a.owner);
    switch(a.subaccount){
      case(null){};
      case(?val){
        accumulator +%= Map.bhash.0(val);
      };
    };
    return accumulator;
  };

  public func account_eq(a : Account, b : Account) : Bool{
    D.print("testing account " # debug_show((a,b)));
    if(a.owner != b.owner) return false;
    switch(a.subaccount, b.subaccount){
      case(null, null){};
      case(?vala, ?valb){
        if(vala != valb) return false;
      };
      case(_,_) return false;
    };
    return true;
  };

  public func account_compare(a : Account, b : Account) : Order.Order {
    if(a.owner == b.owner){
      switch(a.subaccount, b.subaccount){
        case(null, null) return #equal;
        case(?vala, ?valb) return Blob.compare(vala,valb);
        case(null, ?valb) return #less;
        case(?vala, null) return #greater;
      };
    } else return Principal.compare(a.owner, b.owner);
  };

  public let ahash = (account_hash32, account_eq);

  public let token_property_owner_account = "icrc7:owner_account";
  public let token_property_owner_principal = "icrc7:owner_principal";
  public let token_property_owner_subaccount = "icrc7:owner_subaccount";

  public type Environment = {
    canister : () -> Principal;
    get_time : () -> Int;
    refresh_state: () -> State;
    add_ledger_transaction: ?((trx: Transaction, trxtop: ?Transaction) -> Nat);
    can_transfer : ?((trx: Transaction, trxtop: ?Transaction, notificication: TransferNotification) -> Result.Result<(trx: Transaction, trxtop: ?Transaction, notificication: TransferNotification), Text>);
    can_mint : ?((trx: Transaction, trxtop: ?Transaction, notificication: MintNotification) -> Result.Result<(trx: Transaction, trxtop: ?Transaction, notificication: MintNotification), Text>);
    can_burn : ?((trx: Transaction, trxtop: ?Transaction, notificication: BurnNotification) -> Result.Result<(trx: Transaction, trxtop: ?Transaction, notificication: BurnNotification), Text>);
  };

  public type TokenTransferredListener = (TransferNotification, trxid: Nat) -> ();
  public type TokenBurnListener = (BurnNotification, trxid: Nat) -> ();
  public type TokenMintListener = (MintNotification, trxid: Nat) -> ();

  public type Indexes = {
    nft_to_owner : Map.Map<Nat, Account>;
    owner_to_nfts : Map.Map<Account, Set.Set<Nat>>;
    recent_transactions : Map.Map<Blob, (Int,Nat)>;
  };

  public type Constants = {
      token_properties: {
        owner_account: Text;
        owner_principal: Text;
        owner_subaccount: Text;
      };
  };

  public type State = {
    ledger_info : LedgerInfo;
    nfts: Map.Map<Nat, NFT>;
    ledger : Vec.Vector<Value>;
    var owner : Principal;
    indexes: Indexes;
    constants : Constants;
  };

  public type Stats = {
    ledger_info : LedgerInfoShared;
    nft_count: Nat;
    ledger_count : Nat;
    owner : Principal;
    indexes: {
      nft_to_owner_count : Nat;
      owner_to_nfts_count :Nat;
      recent_transactions_count :Nat;
    };
    constants : Constants;
  };
};