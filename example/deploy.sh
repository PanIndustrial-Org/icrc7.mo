set -ex

dfx identity new icrc7_deployer --storage-mode=plaintext || true

dfx identity use icrc7_deployer

ADMIN_PRINCIPAL=$(dfx identity get-principal)

dfx deploy icrc7 --argument 'record {icrc7_args = null; icrc30_args =null}'