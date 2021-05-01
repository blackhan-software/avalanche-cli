#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2046,SC2214,SC2153
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
    usage+=" [-i|--id|--subnet-id=\${AVAX_SUBNET_ID_\$IDX}]*" ;
    usage+=" [-N|--node=\${AVAX_NODE-https://api.avax.network}]" ;
    usage+=" [-S|--silent-rpc|\${AVAX_SILENT_RPC}]" ;
    usage+=" [-V|--verbose-rpc|\${AVAX_VERBOSE_RPC}]" ;
    usage+=" [-Y|--yes-run-rpc|\${AVAX_YES_RUN_RPC}]" ;
    usage+=" [-h|--help]" ;
    source "$CMD_SCRIPT/../../cli/help.sh" ; # shellcheck disable=2046
    printf '%s\n\n%s\n' "$usage" "$(help_for $(command_fqn "${0}"))" ;
}

function cli_options {
    local -a options ;
    options+=( "-i" "--id=" "--subnet-id=" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    local -ag AVAX_SUBNET_IDS=() ;
    get_subnet_ids AVAX_SUBNET_IDS ;
    while getopts ":hSVYN:i:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            i|id|subnet-id)
                local i; i="$(next_index AVAX_SUBNET_IDS)" ;
                AVAX_SUBNET_IDS["$i"]="${OPTARG}" ;;
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
    if [ -z "$AVAX_NODE" ] ; then
        AVAX_NODE="https://api.avax.network" ;
    fi
    shift $((OPTIND-1)) ;
}

function get_subnet_ids {
    environ_vars "$1" "AVAX_SUBNET_ID_([0-9]+)" "${!AVAX_SUBNET_ID_@}" ;
}

function rpc_method {
    printf "platform.getSubnets" ;
}

function rpc_params {
    printf "{" ;
    if [ -n "${AVAX_SUBNET_IDS[*]}" ] ; then
        printf '"ids":[' ;
        join_by ',' $(map_by '"%s" ' "${AVAX_SUBNET_IDS[@]}") ;
        printf ']' ;
    fi
    printf "}" ;
}

###############################################################################

cli "$@" && rpc_post "$AVAX_NODE/ext/P" "$(rpc_data)" ;

###############################################################################
###############################################################################
