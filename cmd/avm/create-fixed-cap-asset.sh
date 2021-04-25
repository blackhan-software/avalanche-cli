#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2214,SC2153,SC2207
###############################################################################
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
    usage+=" [-n|--name=\${AVAX_NAME}]" ;
    usage+=" [-s|--symbol=\${AVAX_SYMBOL}]" ;
    usage+=" [-d|--denomination=\${AVAX_DENOMINATION}]" ;
    usage+=" [-@|--address|--initial-holder-address=\${AVAX_ADDRESS_\$IDX}]*" ;
    usage+=" [-#|--amount|--initial-holder-amount=\${AVAX_AMOUNT_\$IDX}[E|P|T|G|M|K]]*" ;
    usage+=" [-f|--from|--from-address=\${AVAX_FROM_ADDRESS_\$IDX}]*" ;
    usage+=" [-c|--change|--change-address=\${AVAX_CHANGE_ADDRESS}]" ;
    usage+=" [-u|--username=\${AVAX_USERNAME}]" ;
    usage+=" [-p|--password=\${AVAX_PASSWORD}]" ;
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
    options+=( "-n" "--name=" ) ;
    options+=( "-s" "--symbol=" ) ;
    options+=( "-d" "--denomination=" ) ;
    options+=( "-@" "--address=" "--initial-holder-address=" ) ;
    options+=( "-#" "--amount=" "--initial-holder-amount=" ) ;
    options+=( "-f" "--from=" "--from-address=" ) ;
    options+=( "-c" "--change=" "--change-address=" ) ;
    options+=( "-u" "--username=" ) ;
    options+=( "-p" "--password=" ) ;
    options+=( "-b" "--blockchain-id=" "--blockchain-id=X" "--blockchain-id=P" "--blockchain-id=C" ) ;
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
    local -ag AVAX_AMOUNTS=() ;
    get_amounts AVAX_AMOUNTS ;
    local -ag AVAX_FROM_ADDRESSES=() ;
    get_from_addresses AVAX_FROM_ADDRESSES ;
    while getopts ":hSVYH:n:s:d:@:#:f:c:u:p:b:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            n|name)
                AVAX_NAME="${OPTARG}" ;;
            s|symbol)
                AVAX_SYMBOL="${OPTARG}" ;;
            d|denomination)
                AVAX_DENOMINATION="${OPTARG}" ;;
            @|address|initial-holder-address)
                local i; i="$(next_index AVAX_ADDRESSES)" ;
                AVAX_ADDRESSES["$i"]="${OPTARG}" ;;
           \#|amount|initial-holder-amount)
                local i; i="$(next_index AVAX_AMOUNTS)" ;
                AVAX_AMOUNTS["$i"]="${OPTARG}" ;;
            f|from|from-address)
                local i; i="$(next_index AVAX_FROM_ADDRESSES)" ;
                AVAX_FROM_ADDRESSES["$i"]="${OPTARG}" ;;
            c|change|change-address)
                AVAX_CHANGE_ADDRESS="${OPTARG}" ;;
            u|username)
                AVAX_USERNAME="${OPTARG}" ;;
            p|password)
                AVAX_PASSWORD="${OPTARG}" ;;
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
    if [ -z "$AVAX_NAME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_SYMBOL" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_DENOMINATION" ] ; then
        AVAX_DENOMINATION=0 ;
    fi
    if [ -z "${AVAX_ADDRESSES[*]}" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "${AVAX_AMOUNTS[*]}" ] ; then
        cli_help && exit 1 ;
    fi
    if (( "${#AVAX_ADDRESSES[@]}" != "${#AVAX_AMOUNTS[@]}" )) ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_USERNAME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_PASSWORD" ] ; then
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

function get_amounts {
    environ_vars "$1" "AVAX_AMOUNT_([0-9]+)" "${!AVAX_AMOUNT_@}" ;
}

function get_from_addresses {
    environ_vars "$1" "AVAX_FROM_ADDRESS_([0-9]+)" "${!AVAX_FROM_ADDRESS_@}" ;
}

function rpc_method {
    printf "avm.createFixedCapAsset" ;
}

function rpc_params {
    local -a AVAX_AMOUNTS_SI=( $(for n in "${AVAX_AMOUNTS[@]}" ; do
        printf '%s ' "$(si "$n")" ;
    done) ) ;
    printf '{' ;
    printf '"name":"%s",' "$AVAX_NAME" ;
    printf '"symbol":"%s",' "$AVAX_SYMBOL" ;
    printf '"denomination":%s,' "$AVAX_DENOMINATION" ;
    printf '"initialHolders":[' ;
    # shellcheck disable=SC2046
    join_by ',' $( \
        zip_by '{"address":"%s","amount":%s} ' \
            "${AVAX_ADDRESSES[@]}" "${AVAX_AMOUNTS_SI[@]}") ;
    printf '],' ;
    if [ -n "${AVAX_FROM_ADDRESSES[*]}" ] ; then
        printf '"from":[' ; # shellcheck disable=SC2046
        join_by ',' $(map_by '"%s" ' "${AVAX_FROM_ADDRESSES[@]}") ;
        printf '],' ;
    fi
    if [ -n "$AVAX_CHANGE_ADDRESS" ] ; then
        printf '"changeAddr":"%s",' "$AVAX_CHANGE_ADDRESS" ;
    fi
    printf '"username":"%s",' "$AVAX_USERNAME" ;
    printf '"password":"%s"' "$AVAX_PASSWORD" ;
    printf '}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVAX_NODE/ext/bc/$AVAX_BLOCKCHAIN_ID" "$(rpc_data)" ;

###############################################################################
###############################################################################
