import MigrationTypes "../types";
import v0_1_0 "types";

module {

  let Map =  v0_1_0.Map;
  let Set = v0_1_0.Set;
  let Vec = v0_1_0.Vec;

  type Account = v0_1_0.Account;
  type NFT = v0_1_0.NFT;
  type Value = v0_1_0.Value;

  public func upgrade(prevmigration_state: MigrationTypes.State, args: MigrationTypes.Args, caller: Principal): MigrationTypes.State {

    let owner = switch(args){
      case(?val){
        val.deployer;
      };
      case(_) caller;
    };

    let ledger_info = switch(args){
      case(?val){
        {val with
          max_update_batch_size = switch(val.max_update_batch_size){
            case(null) v0_1_0.default_max_update_batch_size;
            case(?val) val;
          };
          max_query_batch_size = switch(val.max_query_batch_size){
            case(null) v0_1_0.default_max_query_batch_size;
            case(?val) val;
          };
          default_take_value = switch(val.default_take_value){
            case(null) v0_1_0.default_default_take_value;
            case(?val) val;
          };
          max_take_value = switch(val.max_take_value){
            case(null) v0_1_0.default_max_take_value;
            case(?val) val;
          };
          max_memo_size = switch(val.max_memo_size){
            case(null) v0_1_0.default_max_memo_size;
            case(?val) val;
          };
          permitted_drift = switch(val.permitted_drift){
            case(null) v0_1_0.default_permitted_drift;
            case(?val) val;
          };
          allow_transfers = switch(val.allow_transfers){
            case(null) v0_1_0.default_allow_transfers;
            case(?val) val;
          };
        };
      };
      case(_) {
        {
          symbol = null;
          name = null;
          description = null;
          logo = null;
          supply_cap = null;
          total_supply = 0;
          max_query_batch_size = v0_1_0.default_max_query_batch_size;
          max_update_batch_size = v0_1_0.default_max_update_batch_size;
          default_take_value = v0_1_0.default_default_take_value;
          max_take_value = v0_1_0.default_max_take_value;
          max_memo_size = v0_1_0.default_max_take_value;
          permitted_drift = v0_1_0.default_permitted_drift;
          allow_transfers = v0_1_0.default_allow_transfers;
          deployer = owner;
        };
      };
    };

    let state = {
      ledger_info : MigrationTypes.Current.LedgerInfo = {
        var symbol = ledger_info.symbol;
        var name = ledger_info.name;
        var description = ledger_info.description;
        var logo = ledger_info.logo;
        var supply_cap = ledger_info.supply_cap;
        var total_supply = 0;
        var max_query_batch_size = ledger_info.max_query_batch_size;
        var max_update_batch_size = ledger_info.max_update_batch_size;
        var default_take_value = ledger_info.default_take_value;
        var max_take_value = ledger_info.max_take_value;
        var max_memo_size = ledger_info.max_memo_size;
        var permitted_drift = ledger_info.permitted_drift;
        var allow_transfers = ledger_info.allow_transfers;
      };

      var owner = owner;
      nfts :  Map.Map<Nat, NFT> = Map.new<Nat, NFT>();
      ledger : Vec.Vector<Value> = Vec.new();
      indexes = {
        nft_to_owner : Map.Map<Nat, Account> = Map.new<Nat, Account>();
        owner_to_nfts : Map.Map<Account, Set.Set<Nat>> = Map.new<Account, Set.Set<Nat>>();
        recent_transactions: Map.Map<Blob, (Int, Nat)> = Map.new<Blob, (Int, Nat)>();
      };
      constants = {
        token_properties = {
          owner_account = MigrationTypes.Current.token_property_owner_account;
          owner_principal = MigrationTypes.Current.token_property_owner_principal;
          owner_subaccount = MigrationTypes.Current.token_property_owner_subaccount;
        };
      };
    };

    return #v0_1_0(#data(state));
  };

  public func downgrade(prev_migration_state: MigrationTypes.State, args: MigrationTypes.Args, caller: Principal): MigrationTypes.State {

    return #v0_0_0(#data);
  };

};