#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2214
###############################################################################
CMD_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CMD_SCRIPT/../../cli/color.sh" ;
source "$CMD_SCRIPT/../../cli/command.sh" ;
source "$CMD_SCRIPT/../../cli/rpc/data.sh" ;
source "$CMD_SCRIPT/../../cli/rpc/post.sh" ;
source "$CMD_SCRIPT/../../cli/si-suffix.sh" ;

###############################################################################
###############################################################################

function cli_help {
    local usage ;
    usage="${BB}Usage:${NB} $(command_fqn "${0}")" ;
    usage+=" [-i|--id=\${AVA_ID}]" ;
    usage+=" [-b|--start-time=\${AVA_START_TIME}]" ;
    usage+=" [-e|--end-timer=\${AVA_END_TIME}]" ;
    usage+=" [-#|--stake-amount=\${AVA_STAKE_AMOUNT}[Y|Z|E|P|T|G|M|K]]" ;
    usage+=" [-%|--payer-nonce=\${AVA_PAYER_NONCE}]" ;
    usage+=" [-@|--destination=\${AVA_DESTINATION}]" ;
    usage+=" [-r|--delegation-fee-rate=\${AVA_DELEGATION_FEE_RATE}]" ;
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
    options+=( "-i" "--id=" ) ;
    options+=( "-b" "--start-time=" ) ;
    options+=( "-e" "--end-time=" ) ;
    options+=( "-#" "--stake-amount=" ) ;
    options+=( "-%" "--payer-nonce=" ) ;
    options+=( "-@" "--destination=" ) ;
    options+=( "-r" "--delegation-fee-rate=" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    while getopts ":hSVYN:i:b:e:#:%:@:r:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            i|id)
                AVA_ID="${OPTARG}" ;;
            b|start-time)
                AVA_START_TIME="${OPTARG}" ;;
            e|end-time)
                AVA_END_TIME="${OPTARG}" ;;
           \#|stake-amount)
                AVA_STAKE_AMOUNT="${OPTARG}" ;;
            %|payer-nonce)
                AVA_PAYER_NONCE="${OPTARG}" ;;
            @|destination)
                AVA_DESTINATION="${OPTARG}" ;;
            r|delegation-fee-rate)
                AVA_DELEGATION_FEE_RATE="${OPTARG}" ;;
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
    if [ -z "$AVA_ID" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_START_TIME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_END_TIME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_STAKE_AMOUNT" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_PAYER_NONCE" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_DESTINATION" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_DELEGATION_FEE_RATE" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_NODE" ] ; then
        AVA_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}

function rpc_method {
    printf "platform.addDefaultSubnetValidator" ;
}

function rpc_params {
    printf '{' ;
    printf '"id":"%s",' "$AVA_ID" ;
    printf '"startTime":%s,' "$AVA_START_TIME" ;
    printf '"endTime":%s,' "$AVA_END_TIME" ;
    printf '"stakeAmount":%s,' "$(si "$AVA_STAKE_AMOUNT")" ;
    printf '"payerNonce":%s,' "$AVA_PAYER_NONCE" ;
    printf '"destination":"%s",' "$AVA_DESTINATION" ;
    printf '"delegationFeeRate":%s' "$AVA_DELEGATION_FEE_RATE" ;
    printf '}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVA_NODE/ext/P" "$(rpc_data)" ;

###############################################################################
###############################################################################
