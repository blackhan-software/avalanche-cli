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

###############################################################################
###############################################################################

function cli_help {
    local usage ;
    usage="${BB}Usage:${NB} $(command_fqn "${0}")" ;
    usage+=" [-#|--amount=\${AVA_AMOUNT}]" ;
    usage+=" [-a|--asset-id=\${AVA_ASSET_ID}]" ;
    usage+=" [-@|--to=\${AVA_TO}]" ;
    usage+=" [-m|--minter=\${AVA_MINTER_\$IDX}]*" ;
    usage+=" [-b|--blockchain-id=\${AVA_BLOCKCHAIN_ID-X}]" ;
    usage+=" [-N|--node=\${AVA_NODE-127.0.0.1:9650}]" ;
    usage+=" [-S|--silent-rpc|\${AVA_SILENT_RPC}]" ;
    usage+=" [-V|--verbose-rpc|\${AVA_VERBOSE_RPC}]" ;
    usage+=" [-Y|--yes-run-rpc|\${AVA_YES_RUN_RPC}]" ;
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
    local -ag AVA_MINTERS=() ;
    get_minters AVA_MINTERS ;
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
                AVA_AMOUNT="${OPTARG}" ;;
            a|asset-id)
                AVA_ASSET_ID="${OPTARG}" ;;
            @|to)
                AVA_TO="${OPTARG}" ;;
            m|minter)
                local i; i="$(next_index AVA_MINTERS)" ;
                AVA_MINTERS["$i"]="${OPTARG}" ;;
            b|blockchain-id)
                AVA_BLOCKCHAIN_ID="${OPTARG}" ;;
            N|node)
                AVA_NODE="${OPTARG}" ;;
            S|silent-rpc)
                export AVA_SILENT_RPC=1 ;;
            V|verbose-rpc)
                export AVA_VERBOSE_RPC=1 ;;
            Y|yes-run-rpc)
                export AVA_YES_RUN_RPC=1 ;;
            h|help)
                cli_help && exit 0 ;;
            :|*)
                cli_help && exit 1 ;;
        esac
    done
    if [ -z "$AVA_AMOUNT" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_ASSET_ID" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_TO" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "${AVA_MINTERS[*]}" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_BLOCKCHAIN_ID" ] ; then
        AVA_BLOCKCHAIN_ID="X" ;
    fi
    if [ -z "$AVA_NODE" ] ; then
        AVA_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}

function get_minters {
    environ_vars "$1" "AVA_MINTER_([0-9]+)" "${!AVA_MINTER_@}" ;
}

function rpc_method {
    printf "avm.createMintTx" ;
}

function rpc_params {
    printf '{' ;
    printf '"amount":%d,' "$AVA_AMOUNT" ;
    printf '"assetID":"%s",' "$AVA_ASSET_ID" ;
    printf '"to":"%s",' "$AVA_TO" ;
    printf '"minters":[' ;
    # shellcheck disable=SC2046
    join_by ',' $(map_by '"%s" ' "${AVA_MINTERS[@]}") ;
    printf ']}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVA_NODE/ext/bc/$AVA_BLOCKCHAIN_ID" "$(rpc_data)" ;

###############################################################################
###############################################################################
