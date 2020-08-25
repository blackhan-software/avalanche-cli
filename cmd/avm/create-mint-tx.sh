#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2214,SC2153,SC2207
##############################################################################
CMD_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CMD_SCRIPT/../../cli/array.sh" ;
source "$CMD_SCRIPT/../../cli/color.sh" ;
source "$CMD_SCRIPT/../../cli/command.sh" ;
source "$CMD_SCRIPT/../../cli/environ.sh" ;
source "$CMD_SCRIPT/../../cli/rpc/data.sh" ;
source "$CMD_SCRIPT/../../cli/rpc/post.sh" ;
source "$CMD_SCRIPT/../../cli/si-suffix.sh" ;

###############################################################################
###############################################################################

function cli_help {
    local usage ;
    usage="${BB}Usage:${NB} $(command_fqn "${0}")" ;
    usage+=" [-#|--amount=\${AVAX_AMOUNT}[E|P|T|G|M|K]]" ;
    usage+=" [-a|--asset-id=\${AVAX_ASSET_ID}]" ;
    usage+=" [-@|--to=\${AVAX_TO}]" ;
    usage+=" [-m|--minter=\${AVAX_MINTER_\$IDX}]*" ;
    usage+=" [-b|--blockchain-id=\${AVAX_BLOCKCHAIN_ID-X}]" ;
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
    options+=( "-#" "--amount=" ) ;
    options+=( "-a" "--asset-id=" ) ;
    options+=( "-@" "--to=" ) ;
    options+=( "-m" "--minter=" ) ;
    options+=( "-b" "--blockchain-id=" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    local -ag AVAX_MINTERS=() ;
    get_minters AVAX_MINTERS ;
    while getopts ":hSVYN:#:a:@:m:u:p:b:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
           \#|amount)
                AVAX_AMOUNT="${OPTARG}" ;;
            a|asset-id)
                AVAX_ASSET_ID="${OPTARG}" ;;
            @|to)
                AVAX_TO="${OPTARG}" ;;
            m|minter)
                local i; i="$(next_index AVAX_MINTERS)" ;
                AVAX_MINTERS["$i"]="${OPTARG}" ;;
            b|blockchain-id)
                AVAX_BLOCKCHAIN_ID="${OPTARG}" ;;
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
    if [ -z "$AVAX_AMOUNT" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_ASSET_ID" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_TO" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "${AVAX_MINTERS[*]}" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_BLOCKCHAIN_ID" ] ; then
        AVAX_BLOCKCHAIN_ID="X" ;
    fi
    if [ -z "$AVAX_NODE" ] ; then
        AVAX_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}

function get_minters {
    environ_vars "$1" "AVAX_MINTER_([0-9]+)" "${!AVAX_MINTER_@}" ;
}

function rpc_method {
    printf "avm.createMintTx" ;
}

function rpc_params {
    printf '{' ;
    printf '"amount":%s,' "$(si "$AVAX_AMOUNT")" ;
    printf '"assetID":"%s",' "$AVAX_ASSET_ID" ;
    printf '"to":"%s",' "$AVAX_TO" ;
    printf '"minters":[' ;
    # shellcheck disable=SC2046
    join_by ',' $(map_by '"%s" ' "${AVAX_MINTERS[@]}") ;
    printf ']}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVAX_NODE/ext/bc/$AVAX_BLOCKCHAIN_ID" "$(rpc_data)" ;

###############################################################################
###############################################################################
