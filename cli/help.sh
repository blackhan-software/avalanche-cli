#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034,SC2059
###############################################################################
CLI_HELP_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CLI_HELP_SCRIPT/color.sh" ;

###############################################################################
###############################################################################

function cli_help {
    printf "${BB}Usage:${NB} $(basename "$0") [OPTIONS] COMMMAND" ;
    printf "\n" ;
    printf "\nA command line interface for Avalanche APIs" ;
    printf "\n" ;
    printf "\n${BB}Options:${NB}" ;
    printf "\n" ;
    printf "$(line_for "-h")" ;
    printf "$(line_for "-v")" ;
    if [[ -z "$1" || "$1" == "admin" ]] ; then
        printf "\n" ;
        printf "\n${BB}Admin API:${NB}\n\n$(text_for 'admin')" ;
        printf "\n" ;
        printf "$(line_for 'admin' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "auth" ]] ; then
        printf "\n" ;
        printf "\n${BB}Authorization (Auth) API:${NB}\n\n$(text_for 'auth')" ;
        printf "\n" ;
        printf "$(line_for 'auth' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "avm" ]] ; then
        printf "\n" ;
        printf "\n${BB}AVM (X-Chain) API:${NB}\n\n$(text_for 'avm')" ;
        printf "\n" ;
        printf "$(line_for 'avm' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "evm" ]] ; then
        printf "\n" ;
        printf "\n${BB}EVM API:${NB}\n\n$(text_for 'evm')" ;
        printf "\n" ;
        printf "$(line_for 'evm' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "health" ]] ; then
        printf "\n" ;
        printf "\n${BB}Health API:${NB}\n\n$(text_for 'health')" ;
        printf "\n" ;
        printf "$(line_for 'health' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "info" ]] ; then
        printf "\n" ;
        printf "\n${BB}Info API:${NB}\n\n$(text_for 'info')" ;
        printf "\n" ;
        printf "$(line_for 'info' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "ipcs" ]] ; then
        printf "\n" ;
        printf "\n${BB}IPC API:${NB}\n\n$(text_for 'ipcs')" ;
        printf "\n" ;
        printf "$(line_for 'ipcs' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "keystore" ]] ; then
        printf "\n" ;
        printf "\n${BB}Keystore API:${NB}\n\n$(text_for 'keystore')" ;
        printf "\n" ;
        printf "$(line_for 'keystore' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "metrics" ]] ; then
        printf "\n" ;
        printf "\n${BB}Metrics API:${NB}\n\n$(text_for 'metrics')" ;
        printf "\n" ;
        printf "$(line_for 'metrics' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "platform" ]] ; then
        printf "\n" ;
        printf "\n${BB}Platform API:${NB}\n\n$(text_for 'platform')" ;
        printf "\n" ;
        printf "$(line_for 'platform' "$2")" ;
    fi
    if [[ -z "$1" || "$1" == "timestamp" ]] ; then
        printf "\n" ;
        printf "\n${BB}Timestamp API:${NB}\n\n$(text_for 'timestamp')" ;
        printf "\n" ;
        printf "$(line_for 'timestamp' "$2")" ;
    fi
}

function line_for {
    local api_max=CLI_HELP_MAX["api"] ;
    local cmd_max=CLI_HELP_MAX["cmd"] ;
    local txt_max=CLI_HELP_MAX["txt"] ;
    local format="\n%s %-$((cmd_max-${#1}))s %s" ;
    for key in "${CLI_HELP_CACHE_ORDER[@]}" ; do
        if [[ "$key" =~ $1:$2 ]] ; then
            local api="${key:0:${#1}}" ;
            local cmd="${key:((${#1}+1))}" ;
            local txt="${CLI_HELP_CACHE[$api:$cmd]}" ;
            if ((${#txt}>txt_max)) ; then
                txt="${txt:0:$txt_max}${NN}.." ;
            fi
            printf "$format" "$api" "$cmd" "$txt" ;
        fi
    done
}

function help_for {
    local api_max=CLI_HELP_MAX["api"] ;
    local cmd_max=CLI_HELP_MAX["cmd"] ;
    for key in "${CLI_HELP_CACHE_ORDER[@]}" ; do
        if [[ "$key" =~ $1:$2 ]] ; then
            local api="${key:0:${#1}}" ;
            local cmd="${key:((${#1}+1))}" ;
            local txt="${CLI_HELP_CACHE[$api:$cmd]}" ;
            printf '%s\n' "$txt" ;
        fi
    done
}

function help_cached {
    local col_max ; col_max=$(tput cols) ;
    local api_max=0 ;
    local cmd_max=0 ;
    local txt_max=0 ;
    for line in "${CLI_HELP[@]}" ; do
        local api ;
        api=$([[ $line =~ ^([^|]+) ]] && printf '%s' "${BASH_REMATCH[1]}") ;
        local cmd ;
        cmd=$([[ $line =~ \|([^|]+)\| ]] && printf '%s'  "${BASH_REMATCH[1]}") ;
        local txt ;
        txt=$([[ $line =~ \|([^|]+)$ ]] && printf '%s'  "${BASH_REMATCH[1]}") ;
        CLI_HELP_CACHE_ORDER+=( "$api:$cmd" ) ;
        CLI_HELP_CACHE["$api:$cmd"]="$txt" ;
        if ((api_max<${#api})) ; then
            api_max=$((${#api})) ;
        fi
        if ((cmd_max<${#api}+${#cmd})) ; then
            cmd_max=$((${#api}+${#cmd})) ;
            txt_max=$((col_max-cmd_max-5)) ;
        fi
    done
    CLI_HELP_MAX["api"]=$api_max ;
    CLI_HELP_MAX["cmd"]=$cmd_max ;
    CLI_HELP_MAX["txt"]=$txt_max ;
}

function text_for {
    for key in "${CLI_TEXT_CACHE_ORDER[@]}" ; do
        if [[ "$key" =~ $1 ]] ; then
            printf "%s" "${CLI_TEXT_CACHE[$key]}" ;
        fi
    done
}

function text_cached {
    for line in "${CLI_TEXT[@]}" ; do
        local api ;
        api=$([[ $line =~ ^([^|]+) ]] && printf '%s' "${BASH_REMATCH[1]}") ;
        CLI_TEXT_CACHE_ORDER+=( "$api" ) ;
        local txt ;
        txt=$([[ $line =~ \|([^|]+)$ ]] && printf '%s' "${BASH_REMATCH[1]}") ;
        CLI_TEXT_CACHE["$api"]="$txt" ;
    done
}

###############################################################################
###############################################################################

declare -a CLI_TEXT
declare -A CLI_TEXT_CACHE
declare -a CLI_TEXT_CACHE_ORDER

declare -a CLI_HELP
declare -A CLI_HELP_MAX
declare -A CLI_HELP_CACHE
declare -a CLI_HELP_CACHE_ORDER

###############################################################################

## Options:
CLI_HELP+=( "-h|--help|Show help information and quit." ) ;
CLI_HELP+=( "-v|--version|Print CLI version information and quit." ) ;

## Admin API:
CLI_TEXT+=( "admin|This API can be used for measuring node health and debugging. Note that the Admin API is disabled by default for security reasons. To run a node with the Admin API enabled, use command line argument ${BB}--api-admin-enabled=true${NB}. See: ${LK}https://docs.avax.network/v1.0/en/api/admin${NN}" ) ;
CLI_HELP+=( "admin|alias|Assign an API an alias, a different endpoint for the API. The original endpoint will still work. This change only affects this node; other nodes will not know about this alias." ) ;
CLI_HELP+=( "admin|alias-chain|Give a blockchain an alias, a different name that can be used any place the blockchain's ID is used." ) ;
CLI_HELP+=( "admin|lock-profile|Dump the mutex statistics of the node to the specified file." ) ;
CLI_HELP+=( "admin|memory-profile|Dump the current memory footprint of the node to the specified file." ) ;
CLI_HELP+=( "admin|start-cpu-profiler|Start profiling the CPU utilization of the node. Will write the profile to the specified file on stop." ) ;
CLI_HELP+=( "admin|stop-cpu-profiler|Stop the CPU profile that was previously started." ) ;

## Auth API:
CLI_TEXT+=( "auth|When you run a node, you can require that API calls have an authorization token attached. This API manages the creation and revocation of authorization tokens. See: ${LK}https://docs.avaxx.network/v1.0/en/api/auth${NN}" ) ;
CLI_HELP+=( "auth|change-password|Change this node's authorization token password. Any authorization tokens created under an old password will become invalid." ) ;
CLI_HELP+=( "auth|new-token|Creates a new authorization token that grants access to one or more API endpoints." ) ;
CLI_HELP+=( "auth|revoke-token|Revoke a previously generated token. The given token will no longer grant access to any endpoint. If the token is invalid, does nothing." ) ;

## AVM (X-Chain) API:
CLI_TEXT+=( "avm|The X-Chain, Avalanche's native platform for creating and trading assets, is an instance of the Avalanche Virtual Machine (AVM). This API allows clients to create and trade assets on the X-Chain and other instances of the AVM. See: ${LK}https://docs.avax.network/v1.0/en/api/avm${NN}")
CLI_HELP+=( "avm|build-genesis|Given a JSON representation of this Virtual Machine's genesis state, create the byte representation of that state." ) ;
CLI_HELP+=( "avm|create-address|Create a new address controlled by the given user." ) ;
CLI_HELP+=( "avm|create-fixed-cap-asset|Create a new fixed-cap, fungible asset. A quantity of it is created at initialization and then no more is ever created. The asset can be sent with 'avm send'." ) ;
CLI_HELP+=( "avm|create-variable-cap-asset|Create a new variable-cap, fungible asset. No units of the asset exist at initialization. Minters can mint units of this asset using 'avm mint'." ) ;
CLI_HELP+=( "avm|export-avax|Send AVAX from the X-Chain to an account on the P-Chain. After calling this method, you must call the P-Chain's 'import-avax' method to complete the transfer." ) ;
CLI_HELP+=( "avm|export-key|Get the private key that controls a given address. The returned private key can be added to a user with 'avm import-key'." ) ;
CLI_HELP+=( "avm|get-all-balances|Get the balances of all assets controlled by a given address." ) ;
CLI_HELP+=( "avm|get-asset-description|Get information about an asset." ) ;
CLI_HELP+=( "avm|get-balance|Get the balance of an asset controlled by a given address." ) ;
CLI_HELP+=( "avm|get-tx|Returns the specified transaction." ) ;
CLI_HELP+=( "avm|get-tx-status|Get the status of a transaction sent to the network." ) ;
CLI_HELP+=( "avm|get-utxos|Get the UTXOs that reference a given address. If 'source-chain' is specified, then it will retrieve the atomic UTXOs exported from that chain to the X chain." ) ;
CLI_HELP+=( "avm|import-avax|Finalize a transfer of AVAX from the P-Chain to the X-Chain. Before this method is called, you must call the P-Chain's 'export-avax' method to initiate the transfer." ) ;
CLI_HELP+=( "avm|import-key|Give a user control over an address by providing the private key that controls the address." ) ;
CLI_HELP+=( "avm|issue-tx|Send a signed transaction to the network." ) ;
CLI_HELP+=( "avm|list-addresses|List addresses controlled by the given user." ) ;
CLI_HELP+=( "avm|mint|Mint units of a variable-cap asset (an asset created with 'avm create-variable-cap-asset')." ) ;
CLI_HELP+=( "avm|send|Send a quantity of an asset to an address." ) ;
CLI_HELP+=( "avm|send-nft|Send a non-fungible token." ) ;

## EVM API:
CLI_TEXT+=( "evm|This section describes the API of the C-Chain, which is an instance of the Ethereum Virtual Machine (EVM). ${BB}Note${NB}: Ethereum has its own notion of 'networkID' and 'chainID'. The C-Chain uses '1' and '43110' for these values, respectively. These have no relationship to AVAX's view of 'networkID' and 'chainID', and are purely internal to the C-Chain. See: ${LK}https://docs.avax.network/v1.0/en/api/evm${NN}")
CLI_HELP+=( "evm|eth-accounts|Returns a list of addresses owned by client. See: ${LK}https://eth.wiki/json-rpc/API#eth_accounts${NN}" )
CLI_HELP+=( "evm|eth-block-number|Returns the number of most recent block. See: ${LK}https://eth.wiki/json-rpc/API#eth_blocknumber${NN}" )
CLI_HELP+=( "evm|eth-call|Executes a new message call immediately without creating a transaction on the block chain. See: ${LK}https://eth.wiki/json-rpc/API#eth_call${NN}" )
CLI_HELP+=( "evm|eth-compile-lll|Returns compiled LLL code. See: ${LK}https://eth.wiki/json-rpc/API#eth_compilelll${NN}" )
CLI_HELP+=( "evm|eth-compile-serpent|Returns compiled serpent code. See: ${LK}https://eth.wiki/json-rpc/API#eth_compileserpent${NN}" )
CLI_HELP+=( "evm|eth-compile-solidity|Returns compiled solidity code. See: ${LK}https://eth.wiki/json-rpc/API#eth_compilesolidity${NN}" )
CLI_HELP+=( "evm|eth-coinbase|Returns the client coinbase address. See: ${LK}https://eth.wiki/json-rpc/API#eth_coinbase${NN}" )
CLI_HELP+=( "evm|eth-estimate-gas|Generates and returns an estimate of how much gas is necessary to allow the transaction to complete. The transaction will not be added to the blockchain. Note that the estimate may be significantly more than the amount of gas actually used by the transaction, for a variety of reasons including EVM mechanics and node performance. See: ${LK}https://eth.wiki/json-rpc/API#eth_estimategas${NN}" )
CLI_HELP+=( "evm|eth-gas-price|Returns the current price per gas in wei. See: ${LK}https://eth.wiki/json-rpc/API#eth_gasprice${NN}" )
CLI_HELP+=( "evm|eth-get-balance|Returns the balance of the account of given address. See: ${LK}https://eth.wiki/json-rpc/API#eth_getbalance${NN}" )
CLI_HELP+=( "evm|eth-get-block-by-hash|Returns information about a block by hash. See: ${LK}https://eth.wiki/json-rpc/API#eth_getblockbyhash${NN}" )
CLI_HELP+=( "evm|eth-get-block-by-number|Returns information about a block by block number. See: ${LK}https://eth.wiki/json-rpc/API#eth_getblockbynumber${NN}" )
CLI_HELP+=( "evm|eth-get-block-transaction-count-by-hash|Returns the number of transactions in a block from a block matching the given block hash. See: ${LK}https://eth.wiki/json-rpc/API#eth_getblocktransactioncountbyhash${NN}" )
CLI_HELP+=( "evm|eth-get-block-transaction-count-by-number|Returns the number of transactions in a block matching the given block number. See: ${LK}https://eth.wiki/json-rpc/API#eth_getblocktransactioncountbynumber${NN}" )
CLI_HELP+=( "evm|eth-get-code|Returns code at a given address. See: ${LK}https://eth.wiki/json-rpc/API#eth_getcode${NN}" )
CLI_HELP+=( "evm|eth-get-compilers|Returns a list of available compilers in the client. See: ${LK}https://eth.wiki/json-rpc/API#eth_getcompilers${NN}" )
CLI_HELP+=( "evm|eth-get-filter-changes|Polling method for a filter, which returns an array of logs which occurred since last poll. See: ${LK}https://eth.wiki/json-rpc/API#eth_getfilterchanges${NN}" )
CLI_HELP+=( "evm|eth-get-filter-logs|Returns an array of all logs matching filter with given id. See: ${LK}https://eth.wiki/json-rpc/API#eth_getfilterlogs${NN}" )
CLI_HELP+=( "evm|eth-get-logs|Returns an array of all logs matching a given filter object. See: ${LK}https://eth.wiki/json-rpc/API#eth_getlogs${NN}" )
CLI_HELP+=( "evm|eth-get-storage-at|Returns the value from a storage position at a given address. See: ${LK}https://eth.wiki/json-rpc/API#eth_getstorageat${NN}" )
CLI_HELP+=( "evm|eth-get-transaction-count|Returns the number of transactions sent from an address. See: ${LK}https://eth.wiki/json-rpc/API#eth_gettransactioncount${NN}" )
CLI_HELP+=( "evm|eth-get-transaction-by-hash|Returns the information about a transaction requested by transaction hash. See: ${LK}https://eth.wiki/json-rpc/API#eth_gettransactionbyhash${NN}" )
CLI_HELP+=( "evm|eth-get-transaction-by-block-hash-and-index|Returns information about a transaction by block hash and transaction index position. See: ${LK}https://eth.wiki/json-rpc/API#eth_gettransactionbyblockhashandindex${NN}" )
CLI_HELP+=( "evm|eth-get-transaction-by-block-number-and-index|Returns information about a transaction by block number and transaction index position. See: ${LK}https://eth.wiki/json-rpc/API#eth_gettransactionbyblocknumberandindex${NN}" )
CLI_HELP+=( "evm|eth-get-transaction-receipt|Returns the receipt of a transaction by transaction hash. See: ${LK}https://eth.wiki/json-rpc/API#eth_gettransactionreceipt${NN}" )
CLI_HELP+=( "evm|eth-get-uncle-by-block-hash-and-index|Returns information about a uncle of a block by hash and uncle index position. See: ${LK}https://eth.wiki/json-rpc/API#eth_getunclebyblockhashandindex${NN}" )
CLI_HELP+=( "evm|eth-get-uncle-by-block-number-and-index|Returns information about a uncle of a block by number and uncle index position. See: ${LK}https://eth.wiki/json-rpc/API#eth_getunclebyblocknumberandindex${NN}" )
CLI_HELP+=( "evm|eth-get-uncle-count-by-block-hash|Returns the number of uncles in a block from a block matching the given block hash. See: ${LK}https://eth.wiki/json-rpc/API#eth_getunclecountbyblockhash${NN}" )
CLI_HELP+=( "evm|eth-get-uncle-count-by-block-number|Returns the number of uncles in a block from a block matching the given block number. See: ${LK}https://eth.wiki/json-rpc/API#eth_getunclecountbyblocknumber${NN}" )
CLI_HELP+=( "evm|eth-get-work|Returns the hash of the current block, the seedHash, and the boundary condition to be met (\"target\"). See: ${LK}https://eth.wiki/json-rpc/API#eth_getwork${NN}" )
CLI_HELP+=( "evm|eth-hashrate|Returns the number of hashes per second that the node is mining with. See: ${LK}https://eth.wiki/json-rpc/API#eth_hashrate${NN}" )
CLI_HELP+=( "evm|eth-mining|Returns true if client is actively mining new blocks. See: ${LK}https://eth.wiki/json-rpc/API#eth_mining${NN}" )
CLI_HELP+=( "evm|eth-new-block-filter|Creates a filter in the node, to notify when a new block arrives. To check if the state has changed, call 'eth_getFilterChanges'. See: ${LK}https://eth.wiki/json-rpc/API#eth_newblockfilter${NN}" )
CLI_HELP+=( "evm|eth-new-filter|Creates a filter object, based on filter options, to notify when the state changes (logs). To check if the state has changed, call 'eth_getFilterChanges'. See: ${LK}https://eth.wiki/json-rpc/API#eth_newfilter${NN}" )
CLI_HELP+=( "evm|eth-new-pending-transaction-filter|Creates a filter in the node, to notify when new pending transactions arrive. To check if the state has changed, call 'eth_getFilterChanges'. See: ${LK}https://eth.wiki/json-rpc/API#eth_newpendingtransactionfilter${NN}" )
CLI_HELP+=( "evm|eth-protocol-version|Returns the current ethereum protocol version. See: ${LK}https://eth.wiki/json-rpc/API#eth_protocolversion${NN}" )
CLI_HELP+=( "evm|eth-send-raw-transaction|Creates new message call transaction or a contract creation for signed transactions. See: ${LK}https://eth.wiki/json-rpc/API#eth_sendrawtransaction${NN}" )
CLI_HELP+=( "evm|eth-sign|The sign method calculates an Ethereum specific signature. See: ${LK}https://eth.wiki/json-rpc/API#eth_sign${NN}" )
CLI_HELP+=( "evm|eth-sign-transaction|Signs a transaction that can be submitted to the network at a later time using with 'eth_sendRawTransaction'. See: ${LK}https://eth.wiki/json-rpc/API#eth_signtransaction${NN}" )
CLI_HELP+=( "evm|eth-send-transaction|Creates new message call transaction or a contract creation, if the data field contains code. See: ${LK}https://eth.wiki/json-rpc/API#eth_sendtransaction${NN}" )
CLI_HELP+=( "evm|eth-submit-work|Used for submitting a proof-of-work solution. See: ${LK}https://eth.wiki/json-rpc/API#eth_submitwork${NN}" )
CLI_HELP+=( "evm|eth-submit-hashrate|Used for submitting mining hashrate. See: ${LK}https://eth.wiki/json-rpc/API#eth_submithashrate${NN}" )
CLI_HELP+=( "evm|eth-syncing|Returns an object with data about the sync status or 'false'. See: ${LK}https://eth.wiki/json-rpc/API#eth_syncing${NN}" )
CLI_HELP+=( "evm|eth-uninstall-filter|Uninstalls a filter with given id. Should always be called when watch is no longer needed. Additonally Filters timeout when they aren't requested with 'eth_getFilterChanges' for a period of time. See: ${LK}https://eth.wiki/json-rpc/API#eth_uninstallfilter${NN}" )
CLI_HELP+=( "evm|personal-ec-recover|Returns the address associated with the private key that was used to calculate the signature in 'personal-sign'. See: ${LK}https://geth.ethereum.org/docs/rpc/ns-personal#personal_ecrecover${NN}") ;
CLI_HELP+=( "evm|personal-import-raw-key|Imports the given unencrypted private key (hex string) into the key store, encrypting it with the passphrase. Returns the address of the new account. See: ${LK}https://geth.ethereum.org/docs/rpc/ns-personal#personal_importrawkey${NN}") ;
CLI_HELP+=( "evm|personal-list-accounts|Returns all the Ethereum account addresses of all keys in the key store. See: ${LK}https://geth.ethereum.org/docs/rpc/ns-personal#personal_listaccounts${NN}") ;
CLI_HELP+=( "evm|personal-lock-account|Removes the private key with given address from memory. The account can no longer be used to send transactions. See: ${LK}https://geth.ethereum.org/docs/rpc/ns-personal#personal_lockaccount${NN}") ;
CLI_HELP+=( "evm|personal-new-account|Generates a new private key and stores it in the key store directory. The key file is encrypted with the given passphrase. Returns the address of the new account. See: ${LK}https://geth.ethereum.org/docs/rpc/ns-personal#personal_newaccount${NN}") ;
CLI_HELP+=( "evm|personal-send-transaction|Validate the given passphrase and submit transaction. The transaction is the same argument as for 'eth-send-transaction' and contains the 'from' address. If the passphrase can be used to decrypt the private key belogging to 'tx.from' the transaction is verified, signed and send onto the network. The account is not unlocked globally in the node and cannot be used in other RPC calls. See: ${LK}https://geth.ethereum.org/docs/rpc/ns-personal#personal_sendtransaction${NN}") ;
CLI_HELP+=( "evm|personal-sign|The sign method calculates an Ethereum specific signature. By adding a prefix to the message makes the calculated signature recognisable as an Ethereum specific signature. This prevents misuse where a malicious DApp can sign arbitrary data (e.g. transaction) and use the signature to impersonate the victim. See 'personal-ec-recover' to verify the signature. See: ${LK}https://geth.ethereum.org/docs/rpc/ns-personal#personal_sign${NN}") ;
CLI_HELP+=( "evm|personal-unlock-account|Decrypts the key with the given address from the key store. Both passphrase and unlock duration are optional when using the JavaScript console. If the passphrase is not supplied as an argument, the console will prompt for the passphrase interactively. The unencrypted key will be held in memory until the unlock duration expires. If the unlock duration defaults to 300 seconds. An explicit duration of zero seconds unlocks the key until geth exits. The account can be used with 'eth-sign' and 'eth-send-transaction' while it is unlocked. See: ${LK}https://geth.ethereum.org/docs/rpc/ns-personal#personal_unlockaccount${NN}") ;
CLI_HELP+=( "evm|net-listening|Returns 'true' if client is actively listening for network connections. See: ${LK}https://eth.wiki/json-rpc/API#net_listening${NN}" ) ;
CLI_HELP+=( "evm|net-peer-count|Returns number of peers currently connected to the client. See: ${LK}https://eth.wiki/json-rpc/API#net_peercount${NN}" ) ;
CLI_HELP+=( "evm|net-version|Returns the current network id. See: ${LK}https://eth.wiki/json-rpc/API#net_version${NN}" ) ;
CLI_HELP+=( "evm|txpool-content|The 'content' inspection property can be queried to list the exact details of all the transactions currently pending for inclusion in the next block(s), as well as the ones that are being scheduled for future execution only. The result is an object with two fields 'pending' and 'queued'. Each of these fields are associative arrays, in which each entry maps an origin-address to a batch of scheduled transactions. These batches themselves are maps associating nonces with actual transactions. Please note, there may be multiple transactions associated with the same account and nonce. This can happen if the user broadcast mutliple ones with varying gas allowances (or even complerely different transactions). See: ${LK}https://geth.ethereum.org/docs/rpc/ns-txpool#txpool_content${NN}") ;
CLI_HELP+=( "evm|txpool-inspect|The 'inspect' inspection property can be queried to list a textual summary of all the transactions currently pending for inclusion in the next block(s), as well as the ones that are being scheduled for future execution only. This is a method specifically tailored to developers to quickly see the transactions in the pool and find any potential issues. The result is an object with two fields 'pending' and 'queued'. Each of these fields are associative arrays, in which each entry maps an origin-address to a batch of scheduled transactions. These batches themselves are maps associating nonces with transactions summary strings. Please note, there may be multiple transactions associated with the same account and nonce. This can happen if the user broadcast mutliple ones with varying gas allowances (or even complerely different transactions). See: ${LK}https://geth.ethereum.org/docs/rpc/ns-txpool#txpool_inspect${NN}") ;
CLI_HELP+=( "evm|txpool-status|The 'status' inspection property can be queried for the number of transactions currently pending for inclusion in the next block(s), as well as the ones that are being scheduled for future execution only. The result is an object with two fields 'pending' and 'queued', each of which is a counter representing the number of transactions in that particular state. See: ${LK}https://geth.ethereum.org/docs/rpc/ns-txpool#txpool_status${NN}") ;
CLI_HELP+=( "evm|web3-client-version|Returns the current client version. See: ${LK}https://eth.wiki/json-rpc/API#web3_clientversion${NN}" ) ;
CLI_HELP+=( "evm|web3-sha3|Returns Keccak-256 (not the standardized SHA3-256) of the given data. See: ${LK}https://eth.wiki/json-rpc/API#web3_sha3${NN}" ) ;

## Health API:
CLI_TEXT+=( "health|This API can be used for measuring node health. See: ${LK}https://docs.avax.network/v1.0/en/api/health${NN}" ) ;
CLI_HELP+=( "health|get-liveness|Get health check on this node." ) ;

## Info API:
CLI_TEXT+=( "info|This API can be used to access basic information about the node. See: ${LK}https://docs.avaxx.network/v1.0/en/api/info${NN}" ) ;
CLI_HELP+=( "info|get-blockchain-id|Given a blockchain's alias, get its ID. (See 'avm alias-chain' for more context)." ) ;
CLI_HELP+=( "info|get-network-id|Get the ID of the network this node is participating in." ) ;
CLI_HELP+=( "info|get-network-name|Get the name of the network this node is running on." ) ;
CLI_HELP+=( "info|get-node-id|Get the ID of this node." ) ;
CLI_HELP+=( "info|get-node-version|Get the version of this node." ) ;
CLI_HELP+=( "info|get-tx-fee|Get the transaction fee of the network." ) ;
CLI_HELP+=( "info|is-bootstrapped|Check whether a given chain is done bootstrapping." ) ;
CLI_HELP+=( "info|peers|Get description of peer connections." ) ;

## IPC API:
CLI_TEXT+=( "ipcs|The IPC API allows users to create UNIX domain sockets for blockchains to publish to. When the blockchain accepts a vertex/block it will publish it to a socket and the decisions contained inside will be published to another. See: ${LK}https://docs.avax.network/v1.0/en/api/ipc${NN}" ) ;
CLI_HELP+=( "ipcs|publish-blockchain|Register a blockchain so it publishes accepted vertices to a Unix domain socket." ) ;
CLI_HELP+=( "ipcs|unpublish-blockchain|Deregister a blockchain so that it no longer publishes to a Unix domain socket." ) ;

## Keystore API:
CLI_TEXT+=( "keystore|Every node has a built-in keystore. Clients create users on the keystore, which act as identities to be used when interacting with blockchains. A keystore exists at the node level, so if you create a user on a node it exists *only* on that node. However, users may be imported and exported using this API. See: ${LK}https://docs.avax.network/v1.0/en/api/keystore${NN}")
CLI_HELP+=( "keystore|create-user|Create a new user with the specified username and password." ) ;
CLI_HELP+=( "keystore|delete-user|Delete a user." ) ;
CLI_HELP+=( "keystore|export-user|Export a user. The user can be imported to another node with 'keystore import-user'. The user's password remains encrypted." ) ;
CLI_HELP+=( "keystore|import-user|Import a user. 'password' must match the user's password. 'username' doesn't have to match the username user had when it was exported." ) ;
CLI_HELP+=( "keystore|list-users|List the users in this keystore." ) ;

## Metrics API:
CLI_TEXT+=( "metrics|The API allows clients to get statistics about a node's health and performance. See: ${LK}https://docs.avax.network/v1.0/en/api/metrics${NN}" ) ;
CLI_HELP+=( "metrics|get-prometheus|Get Prometheus compatible metrics." ) ;

## Platform API:
CLI_TEXT+=( "platform|This API allows clients to interact with the P-Chain (Platform Chain), which maintains Avalanche's validator set and handles blockchain creation. See: ${LK}https://docs.avax.network/v1.0/en/api/platform${NN}")
CLI_HELP+=( "platform|add-delegator|Add a delegator to the primary network. A delegator stakes AVAX and specifies a validator (the delegatee) to validate on their behalf. The delegatee has an increased probability of being sampled by other validators (weight) in proportion to the stake delegated to them. The delegatee charges a fee to the delegator; the former receives a percentage of the delegator's validation reward (if any). The delegation period must be a subset of the period that the delegatee validates the primary network. Note that once you issue the transaction to add a node as a delegator, there is no way to change the parameters. You can't unstake early or change the stake amount, node ID or reward address. Please make sure you're using the correct values. If you're not sure, ask for help on Discord (see https://chat.avalabs.org). See https://docs.avaxx.network/v1.0/en/staking for staking parameters like the minimum amount that can be staked." ) ;
CLI_HELP+=( "platform|add-subnet-validator|Add a validator to a subnet other than the primary network. The validator must validate the primary network for the entire duration they validate this subnet." ) ;
CLI_HELP+=( "platform|add-validator|Add a validator to the Primary Network. You must stake AVAX to do this. If the node is sufficiently correct and responsive while validating, you recieve a reward when they are done validating. The validator's probability of being sampled during by other validators during consensus is in proportion to the amount of AVAX staked. The validator can charge a fee to delegators; the former receives a percentage of the delegator's validation reward (if any.) The minimum delegation fee is 2%. A transaction which adds a validator has no fee. The validation period must be between 2 weeks and 1 year. There is a maximum total weight imposed on validators. This means that no validator will ever have more AVAX staked and delegated to it than this value. This value will initially be set to min(5 * amount staked, 3M AVAX). The total value on a validator is 3 million AVAX. Note that once you issue the transaction to add a node as a validator, there is no way to change the parameters. You can't unstake early or change the stake amount, node ID or reward address. Please make sure you're using the correct values. If you're not sure, ask for help on Discord (see https://chat.avalabs.org). See https://docs.avaxx.network/v1.0/en/staking for staking parameters like the minimum amount that can be staked." ) ;
CLI_HELP+=( "platform|create-address|Create a new address controlled by the given user." ) ;
CLI_HELP+=( "platform|create-blockchain|Create a new blockchain. Currently only supports creation of new instances of the AVM and the Timestamp VM." ) ;
CLI_HELP+=( "platform|create-subnet|Create a new subnet. The subnet's ID is the same as this transaction's ID." ) ;
CLI_HELP+=( "platform|export-avax|Send AVAX from an account on the P-Chain to an address on the X-Chain. This transaction must be signed with the key of the account that the AVAX is sent from and which pays the transaction fee. After issuing this transaction, you must call the X-Chain's 'import-avax' method to complete the transfer." ) ;
CLI_HELP+=( "platform|export-key|Get the private key that controls a given address. The returned private key can be added to a user with 'platform importKey'." ) ;
CLI_HELP+=( "platform|get-balance|Get the balance of AVAX controlled by a given address." ) ;
CLI_HELP+=( "platform|get-blockchains|Get all the blockchains that exist (excluding the P-Chain)." ) ;
CLI_HELP+=( "platform|get-blockchain-status|Get the status of a blockchain." ) ;
CLI_HELP+=( "platform|get-current-validators|List the current validators of the given subnet." ) ;
CLI_HELP+=( "platform|get-height|Returns the height of the last accepted block." ) ;
CLI_HELP+=( "platform|get-min-stake|Get the minimum amount of AVAX required to validate the primary network and the minimum amount of AVAX that can be delegated." ) ;
CLI_HELP+=( "platform|get-pending-validators|List the validators in the pending validator set of the specified subnet. Each validator is not currently validating the subnet but will in the future." ) ;
CLI_HELP+=( "platform|get-stake|Get the amount of nAVAX staked by a set of addresses. The amount returned does not include staking rewards." ) ;
CLI_HELP+=( "platform|get-staking-asset-id|Retrieve an assetID for a subnet's staking asset. Currently this always returns the primary network's staking assetID." ) ;
CLI_HELP+=( "platform|get-subnets|Get all the subnets that exist." ) ;
CLI_HELP+=( "platform|get-tx|Gets a transaction by its ID." ) ;
CLI_HELP+=( "platform|get-tx-status|Gets a transaction's status by its ID." ) ;
CLI_HELP+=( "platform|get-utxo|Gets the UTXOs that reference a given set address." ) ;
CLI_HELP+=( "platform|import-avax|Complete a transfer of AVAX from the X-Chain to the P-Chain. Before this method is called, you must call the X-Chain's 'export-avax' method to initiate the transfer." ) ;
CLI_HELP+=( "platform|import-key|Give a user control over an address by providing the private key that controls the address." ) ;
CLI_HELP+=( "platform|list-addresses|List the addresses controlled by the specified user." ) ;
CLI_HELP+=( "platform|sample-validators|Sample validators from the specified subnet." ) ;
CLI_HELP+=( "platform|validated-by|Get the subnet that validates a given blockchain." ) ;
CLI_HELP+=( "platform|validates|Get the IDs of the blockchains a subnet validates." ) ;

## Timestamp API:
CLI_TEXT+=( "timestamp|This API allows clients to interact with the Timestamp Chain. The Timestamp Chain is a timestamp server. Each block contains a 32 byte payload and the timestamp when the block was created. See: ${LK}https://docs.avax.network/v1.0/en/api/timestamp${NN}" ) ;
CLI_HELP+=( "timestamp|get-block|Get a block by its ID. If no ID is provided, get the latest block." ) ;
CLI_HELP+=( "timestamp|propose-block|Propose the creation of a new block." ) ;

###############################################################################

text_cached ;
help_cached ;

###############################################################################
###############################################################################
