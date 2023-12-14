


module {

  public type Value = { 
    #Blob : Blob; 
    #Text : Text; 
    #Nat : Nat;
    #Int : Int;
    #Array : [Value]; 
    #Map : [(Text, Value)]; 
  };

    // Account Types
	public type Subaccount = Blob;

  /// As descrived by ICRC1
  public type Account = {
    owner: Principal;
    subaccount:  ?Subaccount;
  };

  public type TransferArgs = {
    subaccount : ?Blob;
    to : Account;
    token_ids : [Nat];
    // type: leave open for now
    memo : ?Blob;
    created_at_time : ?Nat64;
  };

   public type TransferResponse = {
    #Ok :[TransferResponseItem];
    #Err : TransferBatchError;
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

  public type TransferError = {
    #NonExistingTokenId;
    #Unauthorized;
    #Duplicate : { duplicate_of : Nat };
    #GenericError : { 
      error_code : Nat; 
      message : Text 
    };
  };

  public type SupportedStandards = [{ name : Text; url : Text }];


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

}