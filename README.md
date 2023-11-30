# icrc7.mo

**Warning: ICRC7 has not been finalized. This is Beta software and should not be used in production until it has been reviewed, audited, and the standard finalized**

## Install
```
mops add icrc7.mo
```

## Usage
```motoko
import ICRC7 "mo:icrc7.mo";
```

## Initialization

This ICRC7 class uses a migration pattern as laid out in https://github.com/ZhenyaUsenko/motoko-migrations, but encapsulates the pattern in the Class+ pattern as described at https://forum.dfinity.org/t/writing-motoko-stable-libraries/21201 . As a result, when you insatiate the class you need to pass the stable memory state into the class:

```
stable var icrc7_migration_state = ICRC7.init(ICRC7.initialState() , #v0_1_0(#id), ?{
        symbol = ?"TST";
        name = ?"Test NFT";
        description = ?"A Test Collection";
        logo = ?"https://www.icpscan.co/img/motoko.jpeg";
        supply_cap = null;
        total_supply = 0;
        max_query_batch_size = ?100;
        max_update_batch_size = ?100;
        default_take_value = ?1000;
        max_take_value = ?10000;
        max_memo_size = ?512;
        permitted_drift = null;
        deployer = init_msg.caller;
        allow_transfers = null;
      } : ICRC7.InitArgs;
    , init_msg.caller);

  let #v0_1_0(#data(icrc7_state_current)) = icrc7_migration_state;

  private var _icrc7 : ?ICRC7.ICRC7 = null;

  private func get_icrc7_environment() : ICRC7.Environment {
    {
      canister = get_canister;
      get_time = get_time;
      refresh_state = get_icrc7_state;
      ledger = ?{
        add_ledger_transaction = add_trx;
      };
    };
  };

  func icrc7() : ICRC7.ICRC7 {
    switch(_icrc7){
      case(null){
        let initclass : ICRC7.ICRC7 = ICRC7.ICRC7(?icrc7_migration_state, Principal.fromActor(this), get_icrc7_environment());
        _icrc7 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

```

The above pattern will allow your class to call icrc().XXXXX to easily access the stable state of your class and you will not have to worry about pre or post upgrade methods.

### Environment

The environment pattern lets you pass dynamic information about your environment to the class.

- get_canister - A function to retrieve the canister this class is running on
- get_time - A function to retrieve the current time to make testing easier
- refresh_state - A function to call to refresh the state of your class. useful in async environments where state may change after an await - provided for future compatibility.
- ledger - used to provide compatibility with ICRC3 based transaction logs. When used in conjucntion with ICRC3.mo you will get an ICRC3 compatible transaction log complete with self archiving.

### Input Init Args

  - symbol - symbol of your nft
  - name - name of your collection
  - description - description of your collection
  - logo - logo for your collection - Can be a URL or a data URL.
  - supply_cap - if your NFT has a supply cap. If you try to set a new NFT above the supply cap, it will block the mint.
  - max_query_batch_size - max query size. defaults to 10,000
  - max_update_batch_size - max updates a user can request at a time. defaults to 10,000;
  - default_take_value - default takes a user can request at a time in a query. defaults to 10,000;
  - max_take_value - max updates a user can request at a time in a query. defaults to 10,000;
  - max_memo_size - max size in bytes for a memo. defaults to 384.
  - permitted_drift - time in nanoseconds that a transaction can be created in the future or past. used for deduplication - Defaults to 2 Minutes (120000000000)
  - allow_transfers - whether this canister allows transfers. defaults to true.
  - deployer - the principal deploying, will be the owner of the collection;

## Metadata and Ownership

This class stores metadata using ICRC16 compliant heiarchical objects.  It utilizes the CandyLibrary(https://github.com/icdevsorg/candy_library) v0.3.0 to do this.

Users may use the Value type as well.

When metadata comes out of the class in ICRC7 it is downgraded to the Value type as described by the standard.

Why use ICRC16 as the input? ICRC16 provides the #Class type which allows an immutable flag on a list of properties.  Using the update_nfts endpoint and property updates the user can change nested values in their metadata but provide assurances that immutable properties cannot be changed.  In addition, internally, Maps and Classes are indexed by key and searches across large datasets can be more easily searched.

Since ICRC16 is a superset of Value, feel free to ignore this functionality and just use the Value Variant options and everything will work as intended.

### Ownership

Ownership is maintained inside the metadata of the NFT in the top level property icrc7:owner_account.  If pushing in data you would format this:

```
#Map([
  ("icrc7:owner_account",
    #Map([
      ("icrc7:owner_principal", #Blob(Principal.toBlob(ownerPrincipal))),
      ("icrc7:owner_subaccount", #Blob(ownerSubaccount)),
    ])
  ),
  //...other properties
])

or

#Class([
  {name = "icrc7:owner_account"; value=#Map([
      ("icrc7:owner_principal", #Blob(Principal.toBlob(ownerPrincipal))),
      ("icrc7:owner_subaccount", #Blob(ownerSubaccount)),
    ]); immutable=false;},
  //...other properties
])

```

If the owner key is not set, the system assumes tha that the canister owns the NFT.

## Deduplication

The class uses a Representational Independent Hash map to keep track of duplicate transactions within the permitted drift timeline.  The hash of the "tx" value is used such that provided memos and created_at_time will keep deduplication from triggering.

## Event system

The class has a register_token_transferred_listener, register_token_mint_listener, and register_token_burn_listener endpoints that allows other objects to register an event listener and be notified whenever a token event occurs from one user to another.

This functionality is used by the ICRC30.mo component to clear approvals whenever a token changes hands or is burned.

```
public type TokenTransferredListener = (token_id: Nat, from: ?Account, to: Account, trxid: Nat) -> ();

public type TokenBurnListener = (token_id: Nat, from: ?Account, trxid: Nat) -> ();

public type TokenMintListener = (token_id: Nat, from: ?Account, to: Account, trxid: Nat, new: Bool) -> ();
  ```