#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2153,SC2214
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
    options+=( "-@" "--address=" ) ;
    options+=( "-b" "--blockchain-id=" ) ;
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
    while getopts ":hSVYN:@:b:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            @|address|initial-holder-address)
                local i; i="$(next_index AVAX_ADDRESSES)" ;
                AVAX_ADDRESSES["$i"]="${OPTARG}" ;;
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
    if [ -z "${AVAX_ADDRESSES[*]}" ] ; then
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

function get_addresses {
    environ_vars "$1" "AVAX_ADDRESS_([0-9]+)" "${!AVAX_ADDRESS_@}" ;
}

function rpc_method {
    printf "avm.getUTXOs" ;
}

function rpc_params {
    printf '{"addresses":[' ; # shellcheck disable=SC2046
    join_by ',' $(map_by '"%s" ' "${AVAX_ADDRESSES[@]}") ;
    printf ']}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVAX_NODE/ext/bc/$AVAX_BLOCKCHAIN_ID" "$(rpc_data)" ;

###############################################################################
###############################################################################
