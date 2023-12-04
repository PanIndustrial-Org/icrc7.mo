import MigrationTypes "./migrations/types";
import Migration "./migrations";

import Array "mo:base/Array";
import D "mo:base/Debug";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Vec "mo:vector";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import RepIndy "mo:rep-indy-hash";

import CandyConversion "mo:candy_0_3_0/conversion";
import CandyProperties "mo:candy_0_3_0/properties";

module {

  /// A debug channel to toggle logging for various aspects of NFT operations.
  ///
  /// Each field corresponds to an operation such as transfer or indexing, allowing
  /// developers to enable or disable logging during development.
  let debug_channel = {
    announce = false;
    get_token_owner = false;
    set_nft = false;
    update_nft = false;
    indexing = false;
    transfer = false;

  };


  public let Map =                         MigrationTypes.Current.Map;
  public let Set =                         MigrationTypes.Current.Set;
  public let Vec =                         MigrationTypes.Current.Vec;
  public let CandyTypes =                  MigrationTypes.Current.CandyTypes;
  public let ahash =                       MigrationTypes.Current.ahash;
  public let account_eq =                  MigrationTypes.Current.account_eq;
  public let account_hash32 =              MigrationTypes.Current.account_hash32;
  public let account_compare =             MigrationTypes.Current.account_compare;
  public let default_max_update_batch_size =  MigrationTypes.Current.default_max_update_batch_size;
  public let default_max_query_batch_size =  MigrationTypes.Current.default_max_query_batch_size;
  public type CurrentState =        MigrationTypes.Current.State;
  public type State =               MigrationTypes.State;
  public type Stats =               MigrationTypes.Current.Stats;
  public type InitArgs =            MigrationTypes.Args;
  public type Error =               MigrationTypes.Current.Error;
  public type Account =             MigrationTypes.Current.Account;
  public type LedgerInfo =          MigrationTypes.Current.LedgerInfo;
  public type NFT =                 MigrationTypes.Current.NFT;
  public type NFTShared =           MigrationTypes.Current.NFTShared;
  public type NFTMap =              MigrationTypes.Current.NFTMap;
  public type NFTInput =            MigrationTypes.Current.NFTInput;
  public type Value =               MigrationTypes.Current.Value;
  public type Indexes =             MigrationTypes.Current.Indexes;
  public type Constants =             MigrationTypes.Current.Constants;
  public type Environment =         MigrationTypes.Current.Environment;
  public type UpdateLedgerInfoRequest = MigrationTypes.Current.UpdateLedgerInfoRequest;
  public type SetNFTRequest =       MigrationTypes.Current.SetNFTRequest;
  public type SetNFTItemResponse =       MigrationTypes.Current.SetNFTItemResponse;
  public type SetNFTBatchResponse =       MigrationTypes.Current.SetNFTBatchResponse;
  public type SetNFTResult =       MigrationTypes.Current.SetNFTResult;
  public type MintNotification =    MigrationTypes.Current.MintNotification;

  public type BurnNFTRequest =       MigrationTypes.Current.BurnNFTRequest;
  public type BurnNFTItemResponse =       MigrationTypes.Current.BurnNFTItemResponse;
  public type BurnNFTBatchResponse =       MigrationTypes.Current.BurnNFTBatchResponse;
  public type BurnNFTResult =       MigrationTypes.Current.BurnNFTResult;
  public type BurnNotification =    MigrationTypes.Current.BurnNotification;

  public type UpdateNFTRequest =       MigrationTypes.Current.UpdateNFTRequest;
  public type UpdateNFTItemResponse =       MigrationTypes.Current.UpdateNFTItemResponse;
  public type UpdateNFTBatchResponse =       MigrationTypes.Current.UpdateNFTBatchResponse;
  public type UpdateNFTResult =       MigrationTypes.Current.UpdateNFTResult;
  

  
  public type SupportedStandards =  MigrationTypes.Current.SupportedStandards;
  public type TokenTransferredListener = MigrationTypes.Current.TokenTransferredListener;
  public type TokenMintListener = MigrationTypes.Current.TokenMintListener;
  public type TokenBurnListener = MigrationTypes.Current.TokenBurnListener;


  public type OwnerOfResponse =             MigrationTypes.Current.OwnerOfResponse;
  public type OwnerOfResponses =            MigrationTypes.Current.OwnerOfResponses;
  
  public type TransferArgs =                MigrationTypes.Current.TransferArgs;
  public type TransferResponse =            MigrationTypes.Current.TransferResponse;
  public type TransferResponseItem =        MigrationTypes.Current.TransferResponseItem;
  public type TransferError =               MigrationTypes.Current.TransferArgs;
  public type TransferNotification =    MigrationTypes.Current.TransferNotification;
  


  /// Represents the state of the NFT collection at initialization.
  ///
  /// Returns:
  ///     State - The initial state of the NFT collection.
  public func initialState() : State {#v0_0_0(#data)};

  /// Contains the current state version of the NFT collection.
  public let currentStateVersion = #v0_1_0(#id);

  /// Initializes the state of the NFT collection, migrating from a previous version if necessary.
  public let init = Migration.migrate;


  public let token_property_owner_account = MigrationTypes.Current.token_property_owner_account;
  public let token_property_owner_principal = MigrationTypes.Current.token_property_owner_principal;
  public let token_property_owner_subaccount = MigrationTypes.Current.token_property_owner_subaccount;

  public type Service = actor {

    icrc7_name: shared query ()-> async Text;
    icrc7_symbol: shared query ()-> async Text;
    icrc7_description: shared query ()-> async ?Text;
    icrc7_logo: shared query ()-> async ?Text;
    icrc7_total_supply: shared query ()-> async Nat;
    icrc7_supply_cap: shared query ()-> async ?Nat;
    icrc7_max_query_batch_size: shared query ()-> async ?Nat;
    icrc7_max_update_batch_size: shared query ()-> async ?Nat;
    icrc7_default_take_value: shared query ()-> async ?Nat;
    icrc7_max_take_value:  shared query ()-> async ?Nat;
    icrc7_max_memo_size:  shared query ()-> async ?Nat;
    icrc7_collection_metadata: shared query ()-> async [(Text, Value)];
    icrc7_token_metadata: shared query ([Nat])-> async [(Nat, [(Text,Value)])];
    icrc7_owner_of: shared query ([Nat])-> async [{token_id: Nat; account:Account}];
    icrc7_balance_of: shared query (Account)-> async Nat;
    icrc7_tokens: shared query (prev: ?Nat, take: ?Nat)-> async [Nat];
    icrc7_tokens_of: shared query (Account, prev : ?Nat, take: ?Nat)-> async [Nat];
    icrc7_transfer: shared (TransferArgs)-> async TransferResponse;
    icrc7_supported_standards: shared query ()-> async SupportedStandards;
  };

  /// #class ICRC7
  ///
  /// The `ICRC7` class encapsulates methods and state necessary to manage a collection
  /// of NFTs (non-fungible tokens), supporting operations like query, transfer, and
  /// updating of NFT data according to the ICRC-7 standard.
  ///
  /// Constructor parameters:
  ///      stored: ?State - The initial state stored for the NFT collection or null.
  ///      canister: Principal - The Principal identifier of the canister managing the NFT collection.
  ///      environment: Environment - The environment context for the ledger.
  public class ICRC7(stored: ?State, canister: Principal, environment: Environment){

    var state : CurrentState = switch(stored){
      case(null) {
        let #v0_1_0(#data(foundState)) = init(initialState(),currentStateVersion, null, canister);
        foundState;
      };
      case(?val) {
        let #v0_1_0(#data(foundState)) = init(val,currentStateVersion, null, canister);
        foundState;
      };
    };

    private let token_transferred_listeners = Vec.new<(Text, TokenTransferredListener)>();
    private let token_mint_listeners = Vec.new<(Text, TokenMintListener)>();
    private let token_burn_listeners = Vec.new<(Text, TokenBurnListener)>();

    public let migrate = Migration.migrate;

    /// Returns the collection level ledger information.
    ///
    /// Returns:
    ///      LedgerInfo - Information about the collection ledger.
    public func get_ledger_info() :  LedgerInfo {
      return state.ledger_info;
    };

    /// Returns the state information.
    ///
    /// Returns:
    ///      CurrentState - All the State from the current class.
    public func get_state() :  CurrentState {
      return state;
    };

    /// Returns the environment for the current Class.
    ///
    /// Returns:
    ///      Environment - Environment info.
    public func get_environment() :  Environment {
      return environment;
    };

    /// Returns the owner of the collection.
    ///
    /// Returns:
    ///      Principal - Entiety that deployed the .
    public func get_collection_owner() :  Principal {
      return state.owner;
    };

    /// Returns the indexes calculated on the class.
    ///
    /// Returns:
    ///      Indexes - Information about the collection.
    public func get_indexes() :  Indexes {
      return state.indexes;
    };

    /// Returns the collection level constants.
    ///
    /// Returns:
    ///      Constants - Information about the collection constants.
    public func get_constants() :  Constants {
      return state.constants;
    };

    /// Retrieves information about a specific token by its ID.
    ///
    /// Parameters:
    ///     token_id: Nat - The ID of the token to query information for.
    ///
    /// Returns:
    ///     ?NFT - An optional NFT struct containing token information if found, or null if the token ID does not exist.
    public func get_token_info(token_id: Nat) :  ?NFT {
      debug if(debug_channel.announce) D.print("get_token_info" # debug_show(token_id));
      return Map.get(state.nfts, Map.nhash, token_id);
      
    };

    /// Retrieves metadata for a list of tokens.
    ///
    /// Parameters:
    ///      token_ids : [Nat] - The list of token ids to retrieve metadata for.
    ///
    /// Returns:
    ///      [(Nat, ?NFT)] - A tuple array with token ids and their corresponding metadata.
    public func get_token_infos(token_ids: [Nat]) : [(Nat, ?NFT)]{
      debug if(debug_channel.announce) D.print("get_token_infos" # debug_show(token_ids));
      func getToken(x: Nat) : ((Nat, ?NFT)){
        return (x, get_token_info(x));
      };
      return Array.map<Nat, (Nat, ?NFT)>(token_ids, getToken);
    };

    /// Retrieves shared metadata for a list of tokens.
    ///
    /// Parameters:
    ///      token_ids : [Nat] - The list of token ids to retrieve shared metadata for.
    ///
    /// Returns:
    ///      Result.Result<[(Nat, ?NFTMap)], Text> - A result containing a tuple array of token ids and their corresponding NFTMap metadata or an error message if the query size exceeds limits.
    public func get_token_infos_shared(token_ids: [Nat]) : Result.Result<[(Nat, ?NFTMap)], Text>{
      debug if(debug_channel.announce) D.print("get_token_infos_shared" # debug_show(token_ids));

    
      if(token_ids.size() > state.ledger_info.max_query_batch_size) return #err("too many tokenids in query. Max is " # Nat.toText(state.ledger_info.max_query_batch_size));
        


      return #ok(Array.map<(Nat, ?NFT), (Nat, ?NFTMap)>(get_token_infos( token_ids), func(x) : (Nat, ?NFTMap){ 
      switch(x.1){
        case(null)(x.0,null);
        case(?val){
          switch(CandyConversion.CandySharedToValue(CandyTypes.shareCandy(val))){
            case(#Map(val)){
              (x.0, ?val);
            };
            case(val){
              (x.0, ?[("metadata" , val)]);
            };
          };
        };
      }}));
    };

    /// Retrieves the account owner for a specific token.
    ///
    /// Parameters:
    ///      token_id : Nat - The identifier of the token for which to retrieve the owner.
    ///
    /// Returns:
    ///      ?OwnerOfResponse - The token's owner information or null if not found.
    public func get_token_owner(token_id: Nat) :  ?OwnerOfResponse {
      debug if(debug_channel.announce) D.print("getting owner" # debug_show(token_id));
      switch(Map.get(state.indexes.nft_to_owner, Map.nhash, token_id)){
        case(null){
          D.print("not in index");
          return null;
        };
        case(?val) return ?{
          token_id = token_id;
          account = ?val;
        };
      };
    };

    /// Retrieves the canonical owner of a token from the metadata.
    ///
    /// Parameters:
    ///      token_id : Nat - The identifier of the token for which to retrieve the owner.
    ///
    /// Returns:
    ///      Result.Result<Account, Error> - The account of the owner or an error if not found or malformed.

    public func get_token_owner_canonical(token_id: Nat) :  Result.Result<Account, Error> {

      debug if(debug_channel.announce) D.print("get_token_owner_canonical" # debug_show(token_id));

      let ?nft_value = Map.get<Nat,NFT>(state.nfts, Map.nhash, token_id) else return #err({
        error_code = 2;
        message = "token doesn't exist"
      });

      debug if(debug_channel.get_token_owner) D.print("nft value" # debug_show(nft_value));

      let (principal, subaccount) = switch(nft_value){
        case(#Map(nft)){
          let ?owner = Map.get(nft, Map.thash, state.constants.token_properties.owner_account) else return #ok({
            owner = environment.canister();
            subaccount = null;
          });

          debug if(debug_channel.get_token_owner) D.print("owner " # debug_show(owner));

          let account = CandyConversion.candyToMap(owner);

          debug if(debug_channel.get_token_owner) D.print("account " # debug_show(account));

          let ?#Blob(principal) = Map.get(account, Map.thash, state.constants.token_properties.owner_principal) else return #err({
            error_code = 4;
            message = "owner malformed"
          });

          let subaccount : ?Blob = switch(Map.get(account, Map.thash, state.constants.token_properties.owner_subaccount)){
            case(null) null;
            case(?#Blob(val)) ?val;
            case(_)return #err({
              error_code = 5;
              message = "subaccount malformed"
            });
          };
          (principal, subaccount)
        };
        case(#Class(nft)){
          let ?owner = Map.get(nft, Map.thash, state.constants.token_properties.owner_account) else return #ok({
            owner = environment.canister();
            subaccount = null;
          });

          debug if(debug_channel.get_token_owner) D.print("owner " # debug_show(owner));

          let account = CandyConversion.candyToMap(owner.value);

          debug if(debug_channel.get_token_owner) D.print("account " # debug_show(account));

          let ?#Blob(principal) = Map.get(account, Map.thash, state.constants.token_properties.owner_principal) else return #err({
            error_code = 4;
            message = "owner malformed"
          });

          let subaccount : ?Blob = switch(Map.get(account, Map.thash, state.constants.token_properties.owner_subaccount)){
            case(null) null;
            case(?#Blob(val)) ?val;
            case(_)return #err({
              error_code = 5;
              message = "subaccount malformed"
            });
          };
          (principal, subaccount)
        };
        case(_){
          return #ok({
            owner = environment.canister();
            subaccount = null;
          });
        };
      };
      return #ok({
        owner = Principal.fromBlob(principal);
        subaccount = subaccount;
      });
    };

    private func get_owner_from_value(nftInput : NFTInput) : Result.Result<Account, Error>{
      let nft = CandyTypes.unshare(nftInput);

      switch(nft){
        case(#Map(nft)){
          let ?owner = Map.get(nft, Map.thash, state.constants.token_properties.owner_account) else return #ok({
            owner = environment.canister();
            subaccount = null;
          });

          debug if(debug_channel.get_token_owner) D.print("owner " # debug_show(owner));

          let account = CandyConversion.candyToMap(owner);

          debug if(debug_channel.get_token_owner) D.print("account " # debug_show(account));

          let ?#Blob(principal) = Map.get(account, Map.thash, state.constants.token_properties.owner_principal) else return #err({
            error_code = 4;
            message = "owner malformed"
          });

          let subaccount : ?Blob = switch(Map.get(account, Map.thash, state.constants.token_properties.owner_subaccount)){
            case(null) null;
            case(?#Blob(val)) ?val;
            case(_)return #err({
              error_code = 5;
              message = "subaccount malformed"
            });
          };
          return #ok({owner = Principal.fromBlob(principal); subaccount = subaccount});
        };
        case(#Class(nft)){
          let ?owner = Map.get(nft, Map.thash, state.constants.token_properties.owner_account) else return #ok({
            owner = environment.canister();
            subaccount = null;
          });

          debug if(debug_channel.get_token_owner) D.print("owner " # debug_show(owner));

          let account = CandyConversion.candyToMap(owner.value);

          debug if(debug_channel.get_token_owner) D.print("account " # debug_show(account));

          let ?#Blob(principal) = Map.get(account, Map.thash, state.constants.token_properties.owner_principal) else return #err({
            error_code = 4;
            message = "owner malformed"
          });

          let subaccount : ?Blob = switch(Map.get(account, Map.thash, state.constants.token_properties.owner_subaccount)){
            case(null) null;
            case(?#Blob(val)) ?val;
            case(_)return #err({
              error_code = 5;
              message = "subaccount malformed"
            });
          };
          #ok({owner = Principal.fromBlob(principal); subaccount = subaccount});
        };
        case(_){
          return #ok({
            owner = environment.canister();
            subaccount = null;
          });
        };
      };
    };

    /// Retrieves the statistical data about the ledger and NFT collection.
    ///
    /// Returns:
    ///      Stats - The statistical data containing ledger and collection details.
    public func get_stats() : Stats{
    return {
      ledger_info = {
        symbol  = state.ledger_info.symbol;
        name    = state.ledger_info.name;
        description = state.ledger_info.description;
        logo = state.ledger_info.logo;
        supply_cap= state.ledger_info.supply_cap;
        max_query_batch_size = state.ledger_info.max_query_batch_size;
        max_update_batch_size = state.ledger_info.max_update_batch_size;
        default_take_value  = state.ledger_info.default_take_value;
        max_take_value= state.ledger_info.max_take_value;
        max_memo_size = state.ledger_info.max_memo_size;
        permitted_drift = state.ledger_info.permitted_drift;
        allow_transfers = state.ledger_info.allow_transfers;
      };
      nft_count = Map.size(state.nfts);
      //the reason this is not a Map of a Map is so that we can preserve the queness of this Map and retire the oldest approvals if the map gets too large.
      ledger_count = Vec.size(state.ledger);
      owner = state.owner;
      indexes = {
        nft_to_owner_count = Map.size(state.indexes.owner_to_nfts);
        owner_to_nfts_count = Map.size(state.indexes.owner_to_nfts);

        recent_transactions_count = Map.size(state.indexes.recent_transactions);
      };
      constants = state.constants;
    };
  };

    /// Retrieves a list of owners for the specified list of token ids.
    ///
    /// Parameters:
    ///      token_ids : [Nat] - The list of token ids to get owners for.
    ///
    /// Returns:
    ///      Result.Result<OwnerOfResponses, Text> - A result containing a list of owners or an error message if the query size exceeds limits.
    public func get_token_owners(token_ids: [Nat]) : Result.Result<OwnerOfResponses, Text>{

      
      if(token_ids.size() > state.ledger_info.max_query_batch_size) return #err("too many tokenids in qurey. Max is " # Nat.toText(state.ledger_info.max_query_batch_size));
        
      
      let items = removeDupes(token_ids);

      let result = Vec.new<OwnerOfResponse>();
      for(thisItem in items.vals()){
        switch(get_token_owner(thisItem)){
          case(null){};
          case(?val){
            Vec.add(result, val);
          };
        };
      };
      return #ok(Vec.toArray(result));
    };

    /// Retrieves the set of tokens owned by an account.
    ///
    /// Parameters:
    ///      account : Account - The owner's account.
    ///
    /// Returns:
    ///      ?Set.Set<Nat> - A set of token ids owned by the account, or null if the account owns no tokens.
    public func get_token_owners_tokens(account: Account) : ?Set.Set<Nat>{
      debug if(debug_channel.announce) D.print("getting tokens owned by " # debug_show(account));
      return Map.get<Account, Set.Set<Nat>>(state.indexes.owner_to_nfts, ahash, account);
    };

    /// Retrieves the count of tokens owned by an account.
    ///
    /// Parameters:
    ///      account : Account - The owner's account.
    ///
    /// Returns:
    ///      Nat - The number of tokens owned by the account.
    public func get_token_owners_tokens_count(account: Account) : Nat {
      return switch(get_token_owners_tokens(account)){
        case(null) 0;
        case(?val) Set.size(val);
      };
    };

    /// Converts metadata to the shared data type.
    ///
    /// Parameters:
    ///      val : CandyTypes.CandyShared - The metadata to convert.
    ///
    /// Returns:
    ///      Value - The shared representation of the metadata.
    public func metadata_to_shared(val: CandyTypes.CandyShared) : Value{
      return CandyConversion.CandySharedToValue(val);
    };


    /// Fetches a paginated list of all tokens in the collection.
    ///
    /// Parameters:
    ///      prev : ?Nat - The previous page's last token id, if paginating.
    ///      take : ?Nat - The number of tokens to take in this batch.
    ///
    /// Returns:
    ///      [Nat] - An array of token ids from the collection.
    public func get_tokens_paginated(prev: ?Nat, take: ?Nat) : [Nat]{

      //this implementation assumes that you have inserted your nft into the NFT collection in 
      //ascending order.  Other strategies such as text based keys turned into nats would be 
      //advised to keep an ordered index and update it anytime there is a new mint.

      let max_take = state.ledger_info.max_take_value;

      let this_take = switch(take){
        case(null){state.ledger_info.default_take_value};
        case(?val){
          if(val > max_take){
            max_take;
          } else{
            val;
          };
        };
      };

      let start = switch(prev){
        case(null) 0;
        case(?val) val;
      };

      let nft_count = Map.size(state.nfts);

      let buf = Vec.new<Nat>();

      debug if(debug_channel.get_token_owner) D.print("about to paginate" # debug_show(nft_count, start, max_take));

      var tracker = 0;
      label search for(thisItem in Map.keys(state.nfts)){
        if(start > tracker){
          debug if(debug_channel.get_token_owner) D.print("skipping" # debug_show(tracker));
          tracker +=1;
          continue search;
        };
        debug if(debug_channel.get_token_owner) D.print("adding" # debug_show(tracker, Vec.size(buf)));
        Vec.add(buf, thisItem);
        if(Vec.size(buf) >= this_take){break search};
        tracker += 1;
      };

      return Vec.toArray(buf);
    };


    /// Fetches a paginated list of tokens owned by an account.
    ///
    /// Parameters:
    ///      account : Account - The owner's account for which to fetch the tokens.
    ///      prev : ?Nat - The previous page's last token id, if paginating.
    ///      take : ?Nat - The number of tokens to take in this batch.
    ///
    /// Returns:
    ///      [Nat] - An array of token ids belonging to the owner.
    public func get_tokens_of_paginated(account: Account, prev: ?Nat, take: ?Nat) : [Nat]{
      
      //this implementation assumes may return tokens out of order. The set will be in the order of insertion

      let max_take = state.ledger_info.max_take_value;

      let this_take = switch(take){
        case(null){state.ledger_info.default_take_value};
        case(?val){
          if(val > max_take){
            max_take;
          } else{
            val;
          };
        };
      };

      let (_bFound, search) = switch(prev){
        case(null) (true, 0);
        case(?val) (false, val);
      };
      var bFound = _bFound;

      let ?thisSet = Map.get(state.indexes.owner_to_nfts, ahash, account) else return [];

      let nft_count = Set.size(thisSet);

      let buf = Vec.new<Nat>();

      var tracker = 0;

      label search for(thisItem in Set.keys(thisSet)){
        if(bFound == false){
          if(search != thisItem){
            tracker +=1;
            continue search;
          } else {
            bFound := true;
            tracker +=1;
            continue search;
          };
        };
        Vec.add(buf,thisItem);
        if(Vec.size(buf) >= this_take){break search};
        tracker += 1;
      };

      return Vec.toArray(buf);
    };

    /// Converts an account to its corresponding Value data type.
    ///
    /// Parameters:
    ///      acc : Account - The account to convert.
    ///
    /// Returns:
    ///      Value - The value representation of the account.
    public func accountToValue(acc : Account) : Value {
        let vec = Vec.new<Value>();
        Vec.add(vec, #Blob(Principal.toBlob(acc.owner)));
        switch(acc.subaccount){
          case(null){};
          case(?val){
            Vec.add(vec, #Blob(val));
          };
        };

        return #Array(Vec.toArray(vec));
      };

    /// Validates the provided memo blob field.
    ///
    /// Parameters:
    ///      val : ?Blob - The memo blob to validate.
    ///
    /// Returns:
    ///      ??Blob - The validated memo or null if invalid or null was provided.
    private func testMemo(val : ?Blob) : ??Blob{
      switch(val){
        case(null) return ?null;
        case(?val){
          let max_memo = state.ledger_info.max_memo_size;
          if(val.size() > max_memo){
            return null;
          };
          return ??val;
        };
      };
    };

    /// Validates the provided expiration timestamp.
    ///
    /// Parameters:
    ///      val : ?Nat64 - The timestamp to validate.
    ///
    /// Returns:
    ///      ??Nat64 - The validated timestamp or null if invalid or null was provided.
    private func testExpiresAt(val : ?Nat64) : ??Nat64{
      switch(val){
        case(null) return ?null;
        case(?val){
          if(Nat64.toNat(val) < environment.get_time()){
            return null;
          };
          return ??val;
        };
      };
    };

    /// Validates the provided creation timestamp.
    ///
    /// Parameters:
    ///      val : ?Nat64 - The timestamp to validate.
    ///      environment: Environment - The ledger environment context.
    ///
    /// Returns:
    ///      Result.<?Nat64, Error> - Either the validated timestamp or an error indicating the reason.
    private func testCreatedAt(val : ?Nat64, environment: Environment) : {
      #ok: ?Nat64;
      #Err: {#TooOld;#InTheFuture: Nat64};
      
    }{
      switch(val){
        case(null) return #ok(null);
        case(?val){
          if(Nat64.toNat(val) > environment.get_time() + state.ledger_info.permitted_drift){
            return #Err(#InTheFuture(Nat64.fromNat(Int.abs(environment.get_time()))));
          };
          if(Nat64.toNat(val) < environment.get_time() - state.ledger_info.permitted_drift){
            return #Err(#TooOld);
          };
          return #ok(?val);
        };
      };
    };

   // events

   type Listener<T> = (Text, T);

    /// Generic function to register a listener.
    ///
    /// Parameters:
    ///     namespace: Text - The namespace identifying the listener.
    ///     remote_func: T - A callback function to be invoked.
    ///     listeners: Vec<Listener<T>> - The list of listeners.
    public func register_listener<T>(namespace: Text, remote_func: T, listeners: Vec.Vector<Listener<T>>) {
      let listener: Listener<T> = (namespace, remote_func);
      switch(Vec.indexOf<Listener<T>>(listener, listeners, func(a: Listener<T>, b: Listener<T>) : Bool {
        Text.equal(a.0, b.0);
      })){
        case(?index){
          Vec.put<Listener<T>>(listeners, index, listener);
        };
        case(null){
          Vec.add<Listener<T>>(listeners, listener);
        };
      };
    };

    /// Registers a listener for when a token is transferred.
    ///
    /// Parameters:
    ///      namespace: Text - The namespace identifying the listener.
    ///      remote_func: TokenTransferredListener - A callback function to be invoked on token transfer.
    public func register_token_transferred_listener(namespace: Text, remote_func : TokenTransferredListener){
      register_listener<TokenTransferredListener>(namespace, remote_func, token_transferred_listeners);
    };

    /// Registers a listener for when a token is minted.
    ///
    /// Parameters:
    ///      namespace: Text - The namespace identifying the listener.
    ///      remote_func: TokenMintListener - A callback function to be invoked on token mint.
    public func register_token_mint_listener(namespace: Text, remote_func : TokenMintListener){
      register_listener<TokenMintListener>(namespace, remote_func, token_mint_listeners);
    };

    /// Registers a listener for when a token is burned.
    ///
    /// Parameters:
    ///      namespace: Text - The namespace identifying the listener.
    ///      remote_func: TokenBurnListener - A callback function to be invoked on token burn.
    public func register_token_burn_listener(namespace: Text, remote_func : TokenBurnListener){
      register_listener<TokenBurnListener>(namespace, remote_func, token_burn_listeners);
    };

    //ledger mangement

    /// Updates the ledger with new information based on the provided requests. This may include changes to 
    /// collection name, description, supply details, and other ledger configurations.
    ///
    /// Parameters:
    ///     request: [UpdateLedgerInfoRequest] - A list of requests for updating ledger information.
    ///
    /// Returns:
    ///     [Bool] - A list of boolean values indicating success or failure for each corresponding update request.
    public func update_ledger_info(request: [UpdateLedgerInfoRequest]) : [Bool]{

      let results = Vec.new<Bool>();
      for(thisItem in request.vals()){
        switch(thisItem){
          case(#Symbol(val)){state.ledger_info.symbol := val};
          case(#Name(val)){state.ledger_info.name := val};
          case(#Description(val)){state.ledger_info.description := val};
          case(#Logo(val)){state.ledger_info.logo := val};
          case(#SupplyCap(val)){state.ledger_info.supply_cap := val};
          case(#MaxQueryBatchSize(val)){state.ledger_info.max_query_batch_size := val};
          case(#MaxUpdateBatchSize(val)){state.ledger_info.max_update_batch_size := val};
          case(#DefaultTakeValue(val)){state.ledger_info.default_take_value := val};
          case(#MaxTakeValue(val)){state.ledger_info.max_take_value := val};
          case(#MaxMemoSize(val)){state.ledger_info.max_memo_size := val};
          case(#PermittedDrift(val)){state.ledger_info.permitted_drift := val};
          case(#AllowTransfers(val)){state.ledger_info.allow_transfers := val};
          case(#UpdateOwner(val)){state.owner := val};
        };
        Vec.add(results, true);
      };
      return Vec.toArray(results);
    };

    //index helper functions

    /// Removes the association between an owner and an NFT.
    /// Parameters:
    ///     token_id: Nat - The token ID to remove ownership of.
    ///     account: Account - The account of the current owner to disassociate from the token.
    ///
    /// Returns:
    ///     Bool - A boolean value indicating if the owner was successfully unindexed from the token.
    private func unindex_owner(token_id: Nat, account: Account) : Bool{

      switch(Map.get(state.indexes.owner_to_nfts, ahash, account)){
        case(null){return false};
        case(?val){
          if(Set.size(val) == 1){
            ignore Map.remove<Account, Set.Set<Nat>>(state.indexes.owner_to_nfts, ahash, account);
          } else {
            ignore Set.remove<Nat>(val, Map.nhash, token_id);
          };
        };
      };
      return true;
    };

    /// Associates an NFT with a new owner in the indexing structures.
    /// Parameters:
    ///     token_id: Nat - The token ID to associate with the new owner.
    ///     owner: Account - The account of the new owner to index.
    ///
    /// Returns:
    ///     Bool - A boolean value indicating if the owner was successfully indexed with the token.
    private func index_owner(token_id : Nat, owner: Account) : Bool {
      ignore Map.put(state.indexes.nft_to_owner, Map.nhash, token_id, owner);
      let idx = switch(Map.get(state.indexes.owner_to_nfts, ahash, owner)){
        case(null){
          let newIndex = Set.new<Nat>();
          ignore Map.put(state.indexes.owner_to_nfts, ahash, owner, newIndex);
          newIndex;
        };
        case(?val) val;
      };
      Set.add(idx, Map.nhash, token_id);

      debug if(debug_channel.indexing)D.print("done indexing");
      return true;
    };

    //Update functions

    public func burn_nfts(caller: Principal, request: BurnNFTRequest): Result.Result<BurnNFTBatchResponse, Text>{
      //check the top level

      let results = Vec.new<BurnNFTItemResponse>();

      let ?(memo) = testMemo(request.memo) else return #err("invalid memo. must be less than " # debug_show(state.ledger_info.max_memo_size) # " bits");

      let created_at_time = switch(testCreatedAt(request.created_at_time, environment)){
        case(#ok(val)) val;
        case(#Err(#TooOld)) return #ok(#Err(#TooOld));
        case(#Err(#InTheFuture(val))) return  #ok(#Err(#CreatedInFuture({ledger_time = Nat64.fromNat(Int.abs(environment.get_time()))})));
      };

      //do the burn

      label proc for(thisItem in request.tokens.vals()){

        //does it currently exist?
        let current_owner = switch(Map.get<Nat, CandyTypes.Candy>(state.nfts, Map.nhash, thisItem)){
          case(null){
            Vec.add(results, {
                token_id = thisItem;
                result = #Err(#NonExistingTokenId);
              });
            continue proc;
          };
          case(?val){
            //this nft is being updated and we need to de-index it.
            switch(get_token_owner_canonical(thisItem)){
              case(#err(_)){
                {
                  owner = environment.canister();
                  subaccount = null;
                }};
              case(#ok(val)){ 
                ignore unindex_owner(thisItem, val);
                val;
              };
            };
          };
        };

        if(caller != current_owner.owner){
          return #ok(#Err(#Unauthorized));
        };

        let trx = Vec.new<(Text, Value)>();
        let trxtop = Vec.new<(Text, Value)>();

        switch(request.memo){
          case(null){};
          case(?val){
            Vec.add(trx,("memo", #Blob(val)));
          };
        };

        switch(request.created_at_time){
          case(null){};
          case(?val){
            Vec.add(trx,("ts", #Nat(Nat64.toNat(val))));
          };
        };

        Vec.add(trx,("tid", #Nat(thisItem)));
        Vec.add(trxtop,("ts", #Nat(Int.abs(environment.get_time()))));

        Vec.add(trxtop,("from", accountToValue(current_owner)));
        
        Vec.add(trx,("op", #Text("7burn")));

        let txMap = #Map(Vec.toArray(trx));
        let txTopMap = #Map(Vec.toArray(trxtop));
        let preNotification = {
          from = current_owner;
          token_id = thisItem;
          memo = request.memo;
          created_at_time = request.created_at_time;
        };

        let(finaltx, finaltxtop, notification) : (Value, ?Value, BurnNotification) = switch(environment.can_burn){
          case(null){
            (txMap, ?txTopMap, preNotification);
          };
          case(?remote_func){
            switch(remote_func(txMap, ?txTopMap, preNotification)){
              case(#ok(val)) val;
              case(#err(tx)){
                Vec.add(results, {
                  token_id = thisItem;
                  result = #Err(#GenericError({error_code = 3849; message = tx}));
                });
                continue proc;
              };
            };
          };
        };


        let transaction_id = switch(environment.add_ledger_transaction){
          case(null){
            //use local ledger. This will not scale
            let final = switch(insert_map(finaltxtop, "tx", finaltx)){
              case(#ok(val)) val;
              case(#err(err)){
                Vec.add(results, {
                  token_id = thisItem;
                  result = #Err(#GenericError({error_code = 3849; message = err}));
                });
                continue proc;
              };
            };
            Vec.add<Value>(state.ledger, final);
            Vec.size(state.ledger) - 1;
          };
          case(?val) val(finaltx, finaltxtop);
        };

        ignore Map.remove<Nat, CandyTypes.Candy>(state.nfts, Map.nhash, thisItem);



        Vec.add(results, {
          token_id = thisItem;
          result = #Ok(transaction_id);
        });

        for(thisEvent in Vec.vals(token_burn_listeners)){
          thisEvent.1(notification, transaction_id);
        };

      };
      return #ok(#Ok(Vec.toArray(results)));
    };

    private func insert_map(top: ?Value, key: Text, val: Value): Result.Result<Value, Text> {
      let foundTop = switch(top){
        case(?val) val;
        case(null) #Map([]);
      };
      switch(foundTop){
        case(#Map(a_map)){
          let vecMap = Vec.fromArray<(Text, Value)>(a_map);
          Vec.add<(Text, Value)>(vecMap, (key, val));
          return #ok(#Map(Vec.toArray(vecMap)));
        };
        case(_) return #err("bad map");
      };
    };

    /// Hard sets (replaces) the metadata for an NFT, potentially creating a new token if it does not already exist.
    /// Parameters:
    ///     request: SetNFTRequest - The request containing NFT data and metadata to set.
    ///
    /// Returns:
    ///     Result.Result<SetNFTBatchResponse, Text> - The outcome of the set operation which could be a batch response 
    ///                                                  with results for each NFT or an error message.
    ///
    /// Will produce a 7mint transaction on the ledger
    public func set_nfts(caller: Principal, request: SetNFTRequest) : Result.Result<SetNFTBatchResponse, Text> {
      
      //todo: Security at this layer?
      //todo: where to handle minting and setting data

      if(caller != state.owner){return #err("unauthorized")};

      let results = Vec.new<SetNFTItemResponse>();

      let ?(memo) = testMemo(request.memo) else return #err("invalid memo. must be less than " # debug_show(state.ledger_info.max_memo_size) # " bits");

      let created_at_time = switch(testCreatedAt(request.created_at_time, environment)){
        case(#ok(val)) val;
        case(#Err(#TooOld)) return #ok(#Err(#TooOld));
        case(#Err(#InTheFuture(val))) return  #ok(#Err(#CreatedInFuture({ledger_time = Nat64.fromNat(Int.abs(environment.get_time()))})));
      };

      label proc for(thisItem in request.tokens.vals()){

        switch(state.ledger_info.supply_cap){
          case(?val){
            if(Map.size(state.nfts) >= val){
              Vec.add(results, {
                token_id = thisItem.token_id;
                result = #Err(#GenericError({error_code=124; message="supply cap hit"}));
              });
            };
          };
          case(null){};
        };

        //does it currently exist?
        let bNew = switch(Map.get<Nat, CandyTypes.Candy>(state.nfts, Map.nhash, thisItem.token_id)){
          case(null){true};
          case(?val){
            if(thisItem.override == false){
              Vec.add(results, {
                token_id = thisItem.token_id;
                result = #Err(#TokenExists);
              });
              continue proc;
            };
            //this nft is being updated and we need to de-index it.
            switch(get_token_owner_canonical(thisItem.token_id)){
              case(#err(_)){};
              case(#ok(val)) ignore unindex_owner(thisItem.token_id, val);
            };
            false;
          };
        };
        let trx = Vec.new<(Text, Value)>();
        let trxtop = Vec.new<(Text, Value)>();

        switch(request.memo){
          case(null){};
          case(?val){
            Vec.add(trx,("memo", #Blob(val)));
          };
        };

        switch(request.created_at_time){
          case(null){};
          case(?val){
            Vec.add(trx,("ts", #Nat(Nat64.toNat(val))));
          };
        };

        Vec.add(trx,("tid", #Nat(thisItem.token_id)));
        Vec.add(trxtop,("ts", #Nat(Int.abs(environment.get_time()))));
        
        Vec.add(trx,("op", #Text("7mint")));
        let thisHash = RepIndy.hash_val(CandyConversion.CandySharedToValue(thisItem.metadata));
        let hash = Blob.fromArray(thisHash);
        Vec.add(trx,("hash", #Blob(hash)));
        Vec.add(trx,("from", accountToValue({owner = caller; subaccount=null})));

        let expected_owner = switch(get_owner_from_value(thisItem.metadata)){
          case(#ok(val)) val;
          case(#err(err)){
            Vec.add(results, {
                token_id = thisItem.token_id;
                result = #Err(#GenericError({error_code= 6453; message="bad owner" # err.message;}));
              });
            continue proc;
          };
        };

        let txMap = #Map(Vec.toArray(trx));
        let txTopMap = #Map(Vec.toArray(trxtop));
        let preNotification = {
            token_id = thisItem.token_id;
            memo = request.memo;
            hash = hash;
            from =  ?{owner = state.owner; subaccount = null};
            to = expected_owner;
            created_at_time = request.created_at_time;
            new_token = bNew;
        };

        let(finaltx, finaltxtop, notification) : (Value, ?Value, MintNotification) = switch(environment.can_mint){
          case(null){
            (txMap, ?txTopMap, preNotification);
          };
          case(?remote_func){
            switch(remote_func(txMap, ?txTopMap, preNotification)){
              case(#ok(val)) val;
              case(#err(tx)){
                Vec.add(results, {
                  token_id = thisItem.token_id;
                  result = #Err(#GenericError({error_code= 6453; message=tx}));
                });
                continue proc;
              };
            };
          };
        };

        let transaction_id = switch(environment.add_ledger_transaction){
          case(null){
            //use local ledger. This will not scale
            Vec.add(trxtop, ("tx", #Map(Vec.toArray(trx))));
            Vec.add(state.ledger, #Map(Vec.toArray(trxtop)));
            Vec.size(state.ledger) - 1;
          };
          case(?val) val(#Map(Vec.toArray(trx)), ?#Map(Vec.toArray(trxtop)));
        };

        

        ignore Map.put<Nat, CandyTypes.Candy>(state.nfts, Map.nhash, thisItem.token_id, CandyTypes.unshare(thisItem.metadata));
        Vec.add(results, {
          token_id = thisItem.token_id;
          result = #Ok(transaction_id);
        });

        debug if(debug_channel.set_nft) D.print("about to check canonical owner" # debug_show(thisItem));

        let new_owner = switch(get_token_owner_canonical(thisItem.token_id)){
          case(#ok(owner)){
             debug if(debug_channel.set_nft) D.print("about to index owner" # debug_show(thisItem));
           
            owner;
          };
          case(_){
            {owner = environment.canister();
            subaccount = null;}
          };
        };

        ignore index_owner(thisItem.token_id, new_owner);

        for(thisEvent in Vec.vals(token_mint_listeners)){
          thisEvent.1(notification,  transaction_id);
        };

      };
      return #ok(#Ok(Vec.toArray(results)));
    };

    /// Updates the metadata for an NFT incrementally based on the changes specified in the request.
    /// Parameters:
    ///     request: UpdateNFTRequest - The request containing the NFT ID and the updates to be applied to the metadata.
    ///
    /// Returns:
    ///     Result.Result<UpdateNFTBatchResponse, Text> - The outcome of the update operation which could be a batch response 
    ///                                                    with results for each update or an error message. 
    ///
    /// Will produce a mint event on the chain. If the item was previously minted this will result in multiple mint records.
    public func update_nfts(caller: Principal, request: UpdateNFTRequest) : Result.Result<UpdateNFTBatchResponse, Text>{

      if(caller != state.owner){return #err("unauthorized")};

      let ?(memo) = testMemo(request.memo) else return #err("invalid memo. must be less than " # debug_show(state.ledger_info.max_memo_size) # " bits");

      let created_at_time = switch(testCreatedAt(request.created_at_time, environment)){
        case(#ok(val)) val;
        case(#Err(#TooOld)) return #ok(#Err(#TooOld));
        case(#Err(#InTheFuture(val))) return  #ok(#Err(#CreatedInFuture({ledger_time = Nat64.fromNat(Int.abs(environment.get_time()))})));
      };


      let results = Vec.new<UpdateNFTItemResponse>();
      label proc for(thisItem in request.tokens.vals()){

        //does it currently exist?
        let bNew = switch(Map.get<Nat, CandyTypes.Candy>(state.nfts, Map.nhash, thisItem.token_id)){
          case(null){
            Vec.add(results, {token_id = thisItem.token_id; result = #Err(#NonExistingTokenId)});
            continue proc;
          };
          case(?val){
            var owner_found : ?Account = null;
            //this nft is being updated and we need to de-index it.
            switch(get_token_owner_canonical(thisItem.token_id)){
              case(#err(_)){};
              case(#ok(val)){
                //do any of the updates affect the owner
                for(thisUpdate in thisItem.updates.vals()){
                  if(thisUpdate.name == token_property_owner_account){
                    owner_found := ?val;
                  };
                };
                
              };
            };
            
            switch(val){
              case(#Class(props)){
                let updatedObject = switch(CandyProperties.updateProperties(props, thisItem.updates)){
                  case(#ok(val)) val;
                  case(#err(err)) {
                    Vec.add(results, {
                      token_id = thisItem.token_id;
                      result = #Err(#GenericError({error_code= 875; message=debug_show(err)}));
                    });
                    continue proc;
                  };
                };

                switch(owner_found){
                  case(?val){
                    ignore unindex_owner(thisItem.token_id, val);
                  };
                  case(null){};
                };

                let newItem = #Class(updatedObject);

                let trx = Vec.new<(Text, Value)>();
                let trxtop = Vec.new<(Text, Value)>();

                switch(request.memo){
                  case(null){};
                  case(?val){
                    Vec.add(trx,("memo", #Blob(val)));
                  };
                };

                switch(request.created_at_time){
                  case(null){};
                  case(?val){
                    Vec.add(trx,("ts", #Nat(Nat64.toNat(val))));
                  };
                };

                Vec.add(trx,("tid", #Nat(thisItem.token_id)));
                Vec.add(trxtop,("ts", #Nat(Int.abs(environment.get_time()))));
                
                Vec.add(trx,("op", #Text("7mint")));
                let thisHash = RepIndy.hash_val(CandyConversion.CandySharedToValue(CandyTypes.shareCandy(newItem)));

                let hash = Blob.fromArray(thisHash);
                Vec.add(trx,("hash", #Blob(hash)));

                let expected_owner = switch(get_owner_from_value(CandyTypes.shareCandy(newItem))){
                
                  case(#ok(val)) val;
                  case(#err(err)){
                    Vec.add(results, {
                        token_id = thisItem.token_id;
                        result = #Err(#GenericError({error_code= 6453; message="bad owner" # err.message;}));
                      });
                    continue proc;
                  };
                };

                let txMap = #Map(Vec.toArray(trx));
                let txTopMap = #Map(Vec.toArray(trxtop));
                let preNotification = {
                      token_id = thisItem.token_id;
                      memo = request.memo;
                      hash = hash;
                      from =  ?{owner = state.owner; subaccount = null};
                      to = expected_owner;
                      created_at_time = request.created_at_time;
                      new_token = false;
                  };

                let(finaltx, finaltxtop, notification) : (Value, ?Value, MintNotification) = switch(environment.can_mint){
                  case(null){
                    (txMap, ?txTopMap, preNotification);
                  };
                  case(?remote_func){
                    switch(remote_func(txMap, ?txTopMap, preNotification)){
                      case(#ok(val)) val;
                      case(#err(tx)){
                        Vec.add(results, {
                          token_id = thisItem.token_id;
                          result = #Err(#GenericError({error_code= 6453; message=tx}));
                        });
                        continue proc;
                      };
                    };
                  };
                };

                let transaction_id = switch(environment.add_ledger_transaction){
                  case(null){
                    //use local ledger. This will not scale
                    Vec.add(trxtop, ("tx", #Map(Vec.toArray(trx))));
                    Vec.add(state.ledger, #Map(Vec.toArray(trxtop)));
                    Vec.size(state.ledger) - 1;
                  };
                  case(?val) val(#Map(Vec.toArray(trx)), ?#Map(Vec.toArray(trxtop)));
                };

                ignore Map.put<Nat, CandyTypes.Candy>(state.nfts, Map.nhash, thisItem.token_id, newItem);
                Vec.add(results, {token_id = thisItem.token_id; result=#Ok(transaction_id);});

                let new_owner = 
                    switch(get_token_owner_canonical(thisItem.token_id)){
                      case(#ok(owner)){
                        debug if(debug_channel.update_nft) D.print("about to index owner" # debug_show(thisItem));
                        owner;
                      };
                      case(_){{
                        owner = environment.canister();
                        subaccount = null;
                      }};
                    };

                ignore index_owner(thisItem.token_id, new_owner);
                        
                  

                for(thisEvent in Vec.vals(token_mint_listeners)){
                  thisEvent.1(notification, transaction_id);
                };
              };
              case(_) return #err("Only Class types supported by update");
            };
          };
        };

        
      };
      return #ok(#Ok(Vec.toArray(results)));
    };

    /// Removes expired recent transactions from the index based on the permitted drift.
    public func cleanUpRecents() : (){
      label clean for(thisItem in Map.entries(state.indexes.recent_transactions)){
        if(thisItem.1.0 + state.ledger_info.permitted_drift < environment.get_time()){
          //we can remove this item;
          ignore Map.remove(state.indexes.recent_transactions, Map.bhash, thisItem.0);
        } else {
          //items are inserted in order in this map so as soon as we hit a still valid item, the rest of the list should still be valid as well
          break clean;
        };
      };
    };

    /// Checks if the given array of token IDs contains duplicated values.
    /// Parameters:
    ///     items: [Nat] - The array of token IDs to check for duplicates.
    ///
    /// Returns:
    ///     Bool - A boolean value indicating if duplicates were found or not.
    public func hasDupes(items : [Nat]) : Bool {
      let aSet = Set.fromIter<Nat>(items.vals(), Map.nhash);
      return Set.size(aSet) != items.size();
    };

    /// Removes duplicate token IDs from a list, ensuring each token ID is unique.
    /// Parameters:
    ///     items: [Nat] - The array of token IDs from which to remove duplicates.
    ///
    /// Returns:
    ///     [Nat] - A list of unique token IDs.
    public func removeDupes(items : [Nat]) : [Nat] {
      let aSet = Set.fromIter<Nat>(items.vals(), Map.nhash);
      return Iter.toArray<Nat>(Set.keys(aSet));
    };

    /// Transfers a set of tokens from one owner to another as specified by `transferArgs`.
    ///
    /// Parameters:
    ///      caller: Principal - The Principal identifier of the caller who initiates the transfer.
    ///      transferArgs: TransferArgs - The arguments specifying the details of the transfer.
    ///
    /// Returns:
    ///      Result<Result<TransferResponse, Text>, Text> - The result of the transfer operation, which may contain a success response or an error message.
    public func transfer(caller: Principal, transferArgs: TransferArgs) : Result.Result<TransferResponse, Text> {

      if(state.ledger_info.allow_transfers == false){
        return #err("transfers not allowed");
      };

      //check that the batch isn't too big
      let safe_batch_size = state.ledger_info.max_update_batch_size;

      if(transferArgs.token_ids.size() == 0){
        return #err("no tokens provided");
      };

      if(hasDupes(transferArgs.token_ids)){
        return #err("duplicate tokens");
      };

      if(transferArgs.token_ids.size() > safe_batch_size){
        return #err("too many tokens transferred at one time");
      };

      //check to and from account not equal
      if(account_eq(transferArgs.to, {owner = caller; subaccount = transferArgs.subaccount})){
        return #ok(#Err(#InvalidRecipient));
      };

      //test that the memo is not too large
      let ?(memo) = testMemo(transferArgs.memo) else return #err("invalid memo. must be less than " # debug_show(state.ledger_info.max_memo_size) # " bits");

      
      //make sure the approval is not too old or too far in the future
      let created_at_time = switch(testCreatedAt(transferArgs.created_at_time, environment)){
        case(#ok(val)) val;
        case(#Err(#TooOld)) return #ok(#Err(#TooOld));
        case(#Err(#InTheFuture(val))) return  #ok(#Err(#CreatedInFuture({ledger_time = Nat64.fromNat(Int.abs(environment.get_time()))})));
      };

      debug if(debug_channel.transfer) D.print("passed checks and calling token transfer");

      return #ok(#Ok(Array.map<Nat, TransferResponseItem>(transferArgs.token_ids,  func(x) : TransferResponseItem { 
          return transfer_token(caller, x, transferArgs);
        }
      )));
    };


    /// Finds a duplicate transaction based on its hash.
    ///
    /// Parameters:
    ///      trxhash : Blob - The hash of the transaction to search for.
    ///
    /// Returns:
    ///      ?Nat - The identifier of the original transaction if a duplicate is found, otherwise null.
    public func find_dupe(trxhash: Blob) : ?Nat {
      switch(Map.get<Blob, (Int,Nat)>(state.indexes.recent_transactions, Map.bhash, trxhash)){
          case(?found){
            if(found.0 + state.ledger_info.permitted_drift > environment.get_time()){
              return ?found.1;
            };
          };
          case(null){};
        };
        return null;
    };

    /// Finalizes the token transfer, updating the ledger and indexes.
    ///
    /// Parameters:
    ///      caller : Principal - The principal of the user initiating the transfer.
    ///      transferArgs : TransferArgs - The transfer arguments containing the token details.
    ///      trx : Vec.Vector<(Text, Value)> - A vector of transaction details.
    ///      trxtop : Vec.Vector<(Text, Value)> - A vector of transaction header details.
    ///      token_id : Nat - The identifier of the token being transferred.
    ///
    /// Returns:
    ///      TransferResponseItem - The result of the transfer operation for the token.
    public func finalize_token_transfer(caller : Principal, transferArgs : TransferArgs, trx : Vec.Vector<(Text, Value)>, trxtop : Vec.Vector<(Text, Value)>, token_id : Nat) : TransferResponseItem{
      //check for duplicate
        let trxhash = Blob.fromArray(RepIndy.hash_val(#Map(Vec.toArray(trx))));

        switch(find_dupe(trxhash)){
          case(?found){
            return {token_id = token_id; transfer_result = #Err(#Duplicate({duplicate_of = found}))};
          };
          case(null){};
        };

        debug if(debug_channel.transfer) D.print("about to move the token");
        //move the token
        switch(update_token_owner(token_id, ?{owner = caller; subaccount = transferArgs.subaccount}, transferArgs.to)){
          case(#ok(updated_nft)){};
          case(#err(err)){return { token_id = token_id; transfer_result = #Err(#GenericError(err))}};
        };

        let txMap = #Map(Vec.toArray(trx));
        let txTopMap = #Map(Vec.toArray(trxtop));
        let preNotification = {
            token_id = token_id;
            memo = transferArgs.memo;
            from =  {owner = caller; subaccount = transferArgs.subaccount};
            to = transferArgs.to;
            created_at_time = transferArgs.created_at_time;
        };

        let(finaltx, finaltxtop, notification) : (Value, ?Value, TransferNotification) = switch(environment.can_transfer){
          case(null){
            (txMap, ?txTopMap, preNotification);
          };
          case(?remote_func){
            switch(remote_func(txMap, ?txTopMap, preNotification)){
              case(#ok(val)) val;
              case(#err(tx)){
                return {
                  token_id = token_id;
                  transfer_result = #Err(#GenericError({error_code= 6453; message=tx}));
                };
              };
            };
          };
        };
        
        debug if(debug_channel.transfer) D.print("getting trx id");
        //implment ledger;
        let transaction_id = switch(environment.add_ledger_transaction){
          case(null){
            //use local ledger. This will not scale
            Vec.add(trxtop, ("tx", #Map(Vec.toArray(trx))));
            Vec.add(state.ledger, #Map(Vec.toArray(trxtop)));
            Vec.size(state.ledger) - 1;
          };
          case(?val) val(#Map(Vec.toArray(trx)), ?#Map(Vec.toArray(trxtop)));
        };

        ignore Map.put<Blob, (Int,Nat)>(state.indexes.recent_transactions, Map.bhash, trxhash, (environment.get_time(), transaction_id));

        cleanUpRecents();

        for(thisEvent in Vec.vals(token_transferred_listeners)){
          thisEvent.1(notification, transaction_id);
        };

        return {token_id = token_id; transfer_result = #Ok(transaction_id)};
    };

    /// Transfers a single token based on the provided transfer arguments.
    ///
    /// Parameters:
    ///      caller : Principal - The principal of the user initiating the transfer.
    ///      token_id : Nat - The identifier of the token being transferred.
    ///      transferArgs : TransferArgs - The transfer arguments containing the token details.
    ///
    /// Returns:
    ///      TransferResponseItem - The result of the transfer operation for the token.
    public func transfer_token(caller: Principal, token_id: Nat, transferArgs: TransferArgs) : TransferResponseItem {

        //make sure that either the caller is the owner
        let ?nft = Map.get<Nat,NFT>(state.nfts, Map.nhash, token_id) else return {token_id = token_id; transfer_result = #Err(#NonExistingTokenId)};

        let owner = switch(get_token_owner_canonical(token_id)){
          case(#err(e)) return { token_id = token_id; transfer_result = #Err(#GenericError(e))};
          case(#ok(val)) val;
        };


        debug if(debug_channel.transfer) D.print("checking owner and caller" # debug_show(owner, caller));

        if(owner.owner != caller){
          return {token_id = token_id; transfer_result= #Err(#Unauthorized)}; //only the owner can approve;
        }; 

        if(owner.subaccount != transferArgs.subaccount) return { token_id = token_id;transfer_result =  #Err(#Unauthorized)}; //from_subaccount must match owner;

        let trx = Vec.new<(Text, Value)>();
        let trxtop = Vec.new<(Text, Value)>();

        switch(transferArgs.memo){
          case(null){};
          case(?val){
            Vec.add(trx,("memo", #Blob(val)));
          };
        };

        switch(transferArgs.created_at_time){
          case(null){};
          case(?val){
            Vec.add(trx,("ts", #Nat(Nat64.toNat(val))));
          };
        };

        Vec.add(trx,("tid", #Nat(token_id)));
        Vec.add(trxtop,("ts", #Nat(Int.abs(environment.get_time()))));
        
        Vec.add(trx,("op", #Text("7xfer")));
        
        Vec.add(trx,("from", accountToValue({owner = caller; subaccount = transferArgs.subaccount})));
        Vec.add(trx,("to", accountToValue({owner = transferArgs.to.owner; subaccount = transferArgs.to.subaccount})));

        return finalize_token_transfer(caller, transferArgs, trx,trxtop, token_id);
    };

    

    /// Updates the owner of a token in the metadata and indexes.
    ///
    /// Parameters:
    ///      token_id : Nat - The identifier of the token for which to update the owner.
    ///      previous_owner : ?Account - The previous owner's account, if there was one.
    ///      target_owner : Account - The new owner's account.
    ///
    /// Returns:
    ///      Result.Result<NFT, Error> - The result of updating the token owner, with the updated NFT or an error.
    public func update_token_owner(token_id: Nat, previous_owner: ?Account, target_owner: Account) :  Result.Result<NFT, Error> {

      let ?nft_value = Map.get<Nat, NFT>(state.nfts, Map.nhash, token_id) else return #err({
        error_code = 2;
        message = "token doesn't exist"
      });

      let new_owner_map = Map.new<Text,CandyTypes.Candy>();
      ignore Map.add<Text,CandyTypes.Candy>(new_owner_map, Map.thash, state.constants.token_properties.owner_principal, #Blob(Principal.toBlob(target_owner.owner)));

      switch(target_owner.subaccount){
        case(null){};
        case(?val){
          ignore Map.add<Text,CandyTypes.Candy>(new_owner_map, Map.thash, state.constants.token_properties.owner_subaccount, #Blob(val));
        };
      };

      switch(nft_value){
        case(#Map(nft)){
          ignore Map.put<Text, CandyTypes.Candy>(nft, Map.thash, state.constants.token_properties.owner_account, #Map(new_owner_map));
        };
        case(#Class(nft)){
          ignore Map.put<Text, CandyTypes.Property>(nft, Map.thash, state.constants.token_properties.owner_account, 
          {
            immutable = false;
            name = state.constants.token_properties.owner_principal;
            value = #Map(new_owner_map)
          })
        };
        case(_)return return #err({
          error_code = 20;
          message = "not ownable"
        });
      };

      //update indexes
      ignore index_owner(token_id, target_owner);

      //unindex previous owner
      
      switch(previous_owner){
        case(?previous_owner){
          ignore unindex_owner(token_id, previous_owner);
        };
        case(null){};
      };

      return #ok(nft_value);
    };

  };

};