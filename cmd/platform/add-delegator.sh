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
source "$CMD_SCRIPT/../../cli/si-suffix.sh" ;

###############################################################################
###############################################################################

function cli_help {
    local usage ;
    usage="${BB}Usage:${NB} $(command_fqn "${0}")" ;
    usage+=" [-i|--node-id=\${AVAX_NODE_ID}]" ;
    usage+=" [-b|--start-time=\${AVAX_START_TIME}]" ;
    usage+=" [-e|--end-timer=\${AVAX_END_TIME}]" ;
    usage+=" [-#|--stake-amount=\${AVAX_STAKE_AMOUNT}[E|P|T|G|M|K]]" ;
    usage+=" [-@|--reward-address=\${AVAX_REWARD_ADDRESS}]" ;
    usage+=" [-f|--from|--from-address=\${AVAX_FROM_ADDRESS_\$IDX}]*" ;
    usage+=" [-c|--change|--change-address=\${AVAX_CHANGE_ADDRESS}]" ;
    usage+=" [-u|--username=\${AVAX_USERNAME}]" ;
    usage+=" [-p|--password=\${AVAX_PASSWORD}]" ;
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
    options+=( "-i" "--node-id=" ) ;
    options+=( "-b" "--start-time=" ) ;
    options+=( "-e" "--end-time=" ) ;
    options+=( "-#" "--stake-amount=" ) ;
    options+=( "-@" "--reward-address=" ) ;
    options+=( "-f" "--from=" "--from-address=" ) ;
    options+=( "-c" "--change=" "--change-address=" ) ;
    options+=( "-u" "--username=" ) ;
    options+=( "-p" "--password=" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    local -ag AVAX_FROM_ADDRESSES=() ;
    get_from_addresses AVAX_FROM_ADDRESSES ;
    while getopts ":hSVYN:i:b:e:#:@:f:c:u:p:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            i|node-id)
                AVAX_NODE_ID="${OPTARG}" ;;
            b|start-time)
                AVAX_START_TIME="${OPTARG}" ;;
            e|end-time)
                AVAX_END_TIME="${OPTARG}" ;;
           \#|stake-amount)
                AVAX_STAKE_AMOUNT="${OPTARG}" ;;
            @|reward-address)
                AVAX_REWARD_ADDRESS="${OPTARG}" ;;
            f|from|from-address)
                local i; i="$(next_index AVAX_FROM_ADDRESSES)" ;
                AVAX_FROM_ADDRESSES["$i"]="${OPTARG}" ;;
            c|change|change-address)
                AVAX_CHANGE_ADDRESS="${OPTARG}" ;;
            u|username)
                AVAX_USERNAME="${OPTARG}" ;;
            p|password)
                AVAX_PASSWORD="${OPTARG}" ;;
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
    if [ -z "$AVAX_NODE_ID" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_START_TIME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_END_TIME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_STAKE_AMOUNT" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_REWARD_ADDRESS" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_USERNAME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_PASSWORD" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_NODE" ] ; then
        AVAX_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}

function get_from_addresses {
    environ_vars "$1" "AVAX_FROM_ADDRESS_([0-9]+)" "${!AVAX_FROM_ADDRESS_@}" ;
}

function rpc_method {
    printf "platform.addDelegator" ;
}

function rpc_params {
    printf '{' ;
    printf '"nodeID":"%s",' "$AVAX_NODE_ID" ;
    printf '"startTime":%s,' "$AVAX_START_TIME" ;
    printf '"endTime":%s,' "$AVAX_END_TIME" ;
    printf '"stakeAmount":%s,' "$(si "$AVAX_STAKE_AMOUNT")" ;
    printf '"rewardAddress":"%s",' "$AVAX_REWARD_ADDRESS" ;
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

cli "$@" && rpc_post "$AVAX_NODE/ext/P" "$(rpc_data)" ;

###############################################################################
###############################################################################
