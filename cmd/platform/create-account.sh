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
    usage+=" [-k|--private-key=\${AVA_PRIVATE_KEY-''}]" ;
    usage+=" [-u|--username=\${AVA_USERNAME}]" ;
    usage+=" [-p|--password=\${AVA_PASSWORD}]" ;
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
    options+=( "-k" "--private-key=" ) ;
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
    while getopts ":hSVYN:k:u:p:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            k|private-key)
                AVA_PRIVATE_KEY="${OPTARG}" ;;
            u|username)
                AVA_USERNAME="${OPTARG}" ;;
            p|password)
                AVA_PASSWORD="${OPTARG}" ;;
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
    if [ -z "$AVA_PRIVATE_KEY" ] ; then
        AVA_PRIVATE_KEY="" ;
    fi
    if [ -z "$AVA_USERNAME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_PASSWORD" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_NODE" ] ; then
        AVA_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}

function rpc_method {
    printf "platform.createAccount" ;
}

function rpc_params {
    printf '{' ;
    if [ -n "$AVA_PRIVATE_KEY" ] ; then
        printf '"privateKey":"%s",' "$AVA_PRIVATE_KEY" ;
    else
        printf '"privateKey":null,' ;
    fi
    printf '"username":"%s",' "$AVA_USERNAME" ;
    printf '"password":"%s"' "$AVA_PASSWORD" ;
    printf '}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVA_NODE/ext/P" "$(rpc_data)" ;

###############################################################################
###############################################################################
