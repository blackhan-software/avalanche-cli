#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2214
###############################################################################
CMD_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CMD_SCRIPT/../../cli/color.sh" ;
source "$CMD_SCRIPT/../../cli/command.sh" ;
source "$CMD_SCRIPT/../../cli/rpc/data.sh" ;
source "$CMD_SCRIPT/../../cli/rpc/post.sh" ;

###############################################################################
###############################################################################

function cli_help {
    local usage ;
    usage="${BB}Usage:${NB} $(command_fqn "${0}")" ;
    usage+=" [-s|--subnet-id=\${AVAX_SUBNET_ID}]" ;
    usage+=" [-v|--vm-id=\${AVAX_VM_ID}]" ;
    usage+=" [-n|--name=\${AVAX_NAME}]" ;
    usage+=" [-g|--genesis-data=\${AVAX_GENESIS_DATA}]" ;
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
    options+=( "-s" "--subnet-id=" ) ;
    options+=( "-v" "--vm-id=" ) ;
    options+=( "-n" "--name=" ) ;
    options+=( "-g" "--genesis-data=" ) ;
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
    while getopts ":hSVYN:s:v:n:g:u:p:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            s|subnet-id)
                AVAX_SUBNET_ID="${OPTARG}" ;;
            v|vm-id)
                AVAX_VM_ID="${OPTARG}" ;;
            n|name)
                AVAX_NAME="${OPTARG}" ;;
            g|genesis-data)
                AVAX_GENESIS_DATA="${OPTARG}" ;;
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
    if [ -z "$AVAX_SUBNET_ID" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_VM_ID" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_NAME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_GENESIS_DATA" ] ; then
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

function rpc_method {
    printf "platform.createBlockchain" ;
}

function rpc_params {
    printf '{' ;
    printf '"subnetID":"%s",' "$AVAX_SUBNET_ID" ;
    printf '"vmID":"%s",' "$AVAX_VM_ID" ;
    printf '"name":"%s",' "$AVAX_NAME" ;
    printf '"genesisData":"%s",' "$AVAX_GENESIS_DATA" ;
    printf '"username":"%s",' "$AVAX_USERNAME" ;
    printf '"password":"%s"' "$AVAX_PASSWORD" ;
    printf '}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVAX_NODE/ext/P" "$(rpc_data)" ;

###############################################################################
###############################################################################
