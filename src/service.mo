module {
  public type Map = [(Text, Value)];

  public type Value = {
    #Int : Int;
    #Map : Map;
    #Nat : Nat;
    #Blob : Blob;
    #Text : Text;
    #Array : [Value];
  };

  public type Account = {
    owner : Principal;
    subaccount : ?Blob;
  };

  public type TransferArgs = {
    subaccount : ?Blob;
    to : Account;
    token_ids : [Nat];
    memo : ?Blob;
    created_at_time : ?Nat64;
  };

  public type TransferBatchError = {
    #InvalidRecipient;
    #TooOld;
    #CreatedInFuture : { ledger_time : Nat64 };
    #GenericError : { error_code : Nat; message : Text };
  };

  public type TransferError = {
    #NonExistingTokenId;
    #Unauthorized;
    #Duplicate : { duplicate_of : Nat };
    #GenericError : { error_code : Nat; message : Text };
  };

  public type TransferResult = {
    #Ok : Nat;
    #Err : TransferError;
  };

  public type TransferResponse = {
    #Ok : [{ token_id : Nat; transfer_result : TransferResult }];
    #Err : TransferBatchError;
  };

  public type Metadata = Map;

  public type CollectionMetadataResponse = Metadata;

  public type TokenMetadataResponse = [{
    token_id : Nat;
    metadata : Metadata;
  }];

  public type OwnerOfResponse = [{
    token_id : Nat;
    account : ?Account;
  }];

  public type SupportedStandardsResponse = [{ name : Text; url : Text }];

  public type Service = actor {
    icrc7_name : shared query () -> async Text;
    icrc7_symbol : shared query () -> async Text;
    icrc7_description : shared query () -> async ?Text;
    icrc7_logo : shared query () -> async ?Text;
    icrc7_total_supply : shared query () -> async Nat;
    icrc7_supply_cap : shared query () -> async ?Nat;
    icrc7_max_query_batch_size : shared query () -> async ?Nat;
    icrc7_max_update_batch_size : shared query () -> async ?Nat;
    icrc7_default_take_value : shared query () -> async ?Nat;
    icrc7_max_take_value : shared query () -> async ?Nat;
    icrc7_max_memo_size : shared query () -> async ?Nat;
    icrc7_collection_metadata : shared query () -> async CollectionMetadataResponse;
    icrc7_token_metadata : shared query ([Nat]) -> async TokenMetadataResponse;
    icrc7_owner_of : shared query ([Nat]) -> async OwnerOfResponse;
    icrc7_balance_of : shared query (Account) -> async Nat;
    icrc7_tokens : shared query (prev : ?Nat, take : ?Nat) -> async [Nat];
    icrc7_tokens_of : shared query (Account, prev : ?Nat, take : ?Nat) -> async [Nat];
    icrc7_transfer : shared (TransferArgs) -> async TransferResponse;
    icrc7_supported_standards : shared query () -> async SupportedStandardsResponse;
  };
};
