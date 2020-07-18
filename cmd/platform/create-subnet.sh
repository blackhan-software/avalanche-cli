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
    usage+=" [-@|--control-key=\${AVA_CONTROL_KEY_\$IDX}]*" ;
    usage+=" [-t|--threshold=\${AVA_THRESHOLD}]" ;
    usage+=" [-%|--payer-nonce=\${AVA_PAYER_NONCE}]" ;
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
    options+=( "-@" "--control-key=" ) ;
    options+=( "-t" "--threshold=" ) ;
    options+=( "-%" "--payer-nonce=" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    local -ag AVA_CONTROL_KEYS=() ;
    get_control_keys AVA_CONTROL_KEYS ;
    while getopts ":hSVYN:@:t:%:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            @|control-key)
                local i; i="$(next_index AVA_CONTROL_KEYS)" ;
                AVA_CONTROL_KEYS["$i"]="${OPTARG}" ;;
            t|threshold)
                AVA_THRESHOLD="${OPTARG}" ;;
            %|payer-nonce)
                AVA_PAYER_NONCE="${OPTARG}" ;;
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
    if [ -z "${AVA_CONTROL_KEYS[*]}" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_THRESHOLD" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_PAYER_NONCE" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_NODE" ] ; then
        AVA_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}

function get_control_keys {
    environ_vars "$1" "AVA_CONTROL_KEY_([0-9]+)" "${!AVA_CONTROL_KEY_@}" ;
}

function rpc_method {
    printf "platform.createSubnet" ;
}

function rpc_params {
    printf '{' ;
    printf '"controlKeys":[' ; # shellcheck disable=SC2046
    join_by ',' $(map_by '"%s" ' "${AVA_CONTROL_KEYS[@]}") ;
    printf '],' ;
    printf '"threshold":%s,' "$AVA_THRESHOLD" ;
    printf '"payerNonce":%s' "$AVA_PAYER_NONCE" ;
    printf '}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVA_NODE/ext/P" "$(rpc_data)" ;

###############################################################################
###############################################################################
