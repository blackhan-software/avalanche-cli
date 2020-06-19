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
    usage+=" [-n|--name=\${AVA_NAME}]" ;
    usage+=" [-s|--symbol=\${AVA_SYMBOL}]" ;
    usage+=" [-d|--denomination=\${AVA_DENOMINATION}]" ;
    usage+=" [-m|--minter=\${AVA_MINTERS_\$IDX}]*" ;
    usage+=" [-t|--threshold=\${AVA_THRESHOLD_\$IDX}]*" ;
    usage+=" [-u|--username=\${AVA_USERNAME}]" ;
    usage+=" [-p|--password=\${AVA_PASSWORD}]" ;
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
    options+=( "-n" "--name=" ) ;
    options+=( "-s" "--symbol=" ) ;
    options+=( "-d" "--denomination=" ) ;
    options+=( "-m" "--minter=" ) ;
    options+=( "-t" "--threshold=" ) ;
    options+=( "-u" "--username=" ) ;
    options+=( "-p" "--password=" ) ;
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
    local -ag AVA_THRESHOLDS=() ;
    get_thresholds AVA_THRESHOLDS ;
    while getopts ":hSVYN:n:s:d:m:t:u:p:b:-:" OPT "$@"
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
                AVA_NAME="${OPTARG}" ;;
            s|symbol)
                AVA_SYMBOL="${OPTARG}" ;;
            d|denomination)
                AVA_DENOMINATION="${OPTARG}" ;;
            m|minters)
                local i; i="$(next_index AVA_THRESHOLDS)" ;
                AVA_MINTERS[$i]="${AVA_MINTERS[$i]} ${OPTARG}" ;;
            t|threshold)
                local i; i="$(next_index AVA_THRESHOLDS)" ;
                AVA_THRESHOLDS["$i"]="${OPTARG}" ;;
            u|username)
                AVA_USERNAME="${OPTARG}" ;;
            p|password)
                AVA_PASSWORD="${OPTARG}" ;;
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
    if [ -z "$AVA_NAME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_SYMBOL" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_DENOMINATION" ] ; then
        AVA_DENOMINATION=0 ;
    fi
    if [ -z "${AVA_THRESHOLDS[*]}" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "${AVA_MINTERS[*]}" ] ; then
        cli_help && exit 1 ;
    fi
    if (( "${#AVA_MINTERS[@]}" != "${#AVA_THRESHOLDS[@]}" )) ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_USERNAME" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVA_PASSWORD" ] ; then
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
    environ_vars "$1" "AVA_MINTERS_([0-9]+)" "${!AVA_MINTERS_@}" ;
}

function get_thresholds {
    environ_vars "$1" "AVA_THRESHOLD_([0-9]+)" "${!AVA_THRESHOLD_@}" ;
}

function rpc_method {
    printf "avm.createVariableCapAsset" ;
}

function rpc_params {
    printf '{' ;
    printf '"name":"%s",' "$AVA_NAME" ;
    printf '"symbol":"%s",' "$AVA_SYMBOL" ;
    printf '"denomination":%d,' "$AVA_DENOMINATION" ;
    printf '"minterSets":[' ;

    # shellcheck disable=SC2046,SC2086
    join_by ',' $(for T in "${!AVA_THRESHOLDS[@]}" ; do
        printf '{' ;
        printf '"minters":%s,' "[$( \
            join_by ',' $(map_by '"%s" ' ${AVA_MINTERS[$T]}))]" ;
        printf '"threshold":%s' "${AVA_THRESHOLDS[$T]}";
        printf '} ' ;
    done) ;

    printf '],' ;
    printf '"username":"%s",' "$AVA_USERNAME" ;
    printf '"password":"%s"' "$AVA_PASSWORD" ;
    printf '}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVA_NODE/ext/bc/$AVA_BLOCKCHAIN_ID" "$(rpc_data)" ;

###############################################################################
###############################################################################
