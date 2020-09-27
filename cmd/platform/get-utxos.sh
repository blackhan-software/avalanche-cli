#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2046,SC2214,SC2153
###############################################################################
CMD_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CMD_SCRIPT/../../cli/array.sh" ;
source "$CMD_SCRIPT/../../cli/color.sh" ;
source "$CMD_SCRIPT/../../cli/command.sh" ;
source "$CMD_SCRIPT/../../cli/environ.sh" ;
source "$CMD_SCRIPT/../../cli/rpc/data.sh" ;
source "$CMD_SCRIPT/../../cli/rpc/post.sh" ;

###############################################################################
###############################################################################

function cli_help {
    local usage ;
    usage="${BB}Usage:${NB} $(command_fqn "${0}")" ;
    usage+=" [-@|--address=\${AVAX_ADDRESS_\$IDX}]*" ;
    usage+=" [-l|--limit=\${AVAX_LIMIT-1024}]" ;
    usage+=" [--start-index-address=\${AVAX_START_INDEX_ADDRESS}]" ;
    usage+=" [--start-index-utxo=\${AVAX_START_INDEX_UTXO}]" ;
    usage+=" [-s|--source-chain=\${AVAX_SOURCE_CHAIN}]" ;
    usage+=" [-N|--node=\${AVAX_NODE-127.0.0.1:9650}]" ;
    usage+=" [-S|--silent-rpc|\${AVAX_SILENT_RPC}]" ;
    usage+=" [-V|--verbose-rpc|\${AVAX_VERBOSE_RPC}]" ;
    usage+=" [-Y|--yes-run-rpc|\${AVAX_YES_RUN_RPC}]" ;
    usage+=" [-h|--help]" ;
    source "$CMD_SCRIPT/../../cli/help.sh" ; # shellcheck disable=2046
    printf '%s\n\n%s\n' "$usage" "$(help_for $(command_fqn "${0}"))" ;
}

function cli_options {
    local -a options ;
    options+=( "-@" "--address=" ) ;
    options+=( "-l" "--limit=" ) ;
    options+=( "--start-index-address=" ) ;
    options+=( "--start-index-utxo=" ) ;
    options+=( "-s" "--source-chain=" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    local -ag AVAX_ADDRESSES=() ;
    get_addresses AVAX_ADDRESSES ;
    while getopts ":hSVYN:@:l:s:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            @|address)
                local i; i="$(next_index AVAX_ADDRESSES)" ;
                AVAX_ADDRESSES["$i"]="${OPTARG}" ;;
            l|limit)
                AVAX_LIMIT="${OPTARG}" ;;
            start-index-address)
                AVAX_START_INDEX_ADDRESS="${OPTARG}" ;;
            start-index-utxo)
                AVAX_START_INDEX_UTXO="${OPTARG}" ;;
            s|source-chain)
                AVAX_SOURCE_CHAIN="${OPTARG}" ;;
            N|node)
                AVAX_NODE="${OPTARG}" ;;
            S|silent-rpc)
                export AVAX_SILENT_RPC=1 ;;
            V|verbose-rpc)
                export AVAX_VERBOSE_RPC=1 ;;
            Y|yes-run-rpc)
                export AVAX_YES_RUN_RPC=1 ;;
            h|help)
                cli_help && exit 0 ;;
            :|*)
                cli_help && exit 1 ;;
        esac
    done
    if [ -z "${AVAX_ADDRESSES[*]}" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_LIMIT" ] ; then
        AVAX_LIMIT="1024" ;
    fi
    if [ -n "$AVAX_START_INDEX_ADDRESS" ] ; then
        if [ -z "$AVAX_START_INDEX_UTXO" ] ; then
            cli_help && exit 1 ;
        fi
    fi
    if [ -z "$AVAX_START_INDEX_ADDRESS" ] ; then
        if [ -n "$AVAX_START_INDEX_UTXO" ] ; then
            cli_help && exit 1 ;
        fi
    fi
    if [ -z "$AVAX_NODE" ] ; then
        AVAX_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}

function get_addresses {
    environ_vars "$1" "AVAX_ADDRESS_([0-9]+)" "${!AVAX_ADDRESS_@}" ;
}

function rpc_method {
    printf "platform.getUTXOs" ;
}

function rpc_params {
    printf "{" ;
    printf '"addresses":[' ;
    join_by ',' $(map_by '"%s" ' "${AVAX_ADDRESSES[@]}") ;
    printf ']' ;
    if [ -n "$AVAX_LIMIT" ] ; then
        printf ',' ;
        printf '"limit":%s' "$AVAX_LIMIT" ;
    fi
    if [ -n "$AVAX_START_INDEX_ADDRESS" ] ; then
        if [ -n "$AVAX_START_INDEX_UTXO" ] ; then
            printf ','
            printf '"startIndex":{'
            printf '"address":"%s",' "$AVAX_START_INDEX_ADDRESS"
            printf '"utxo":"%s"' "$AVAX_START_INDEX_UTXO"
            printf '}'
        fi
    fi
    if [ -n "$AVAX_SOURCE_CHAIN" ] ; then
        printf ',' ;
        printf '"sourceChain":"%s"' "$AVAX_SOURCE_CHAIN" ;
    fi
    printf "}" ;
}

###############################################################################

cli "$@" && rpc_post "$AVAX_NODE/ext/P" "$(rpc_data)" ;

###############################################################################
###############################################################################
