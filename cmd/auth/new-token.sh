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

###############################################################################
###############################################################################

function cli_help {
    local usage ;
    usage="${BB}Usage:${NB} $(command_fqn "${0}")" ;
    usage+=" [-e|--endpoint=\${AVAX_ENDPOINT_\$IDX}]*" ;
    usage+=" [-p|--password=\${AVAX_AUTH_PASSWORD}]" ;
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
    options+=( "-e" "--endpoint=" ) ;
    options+=( "-p" "--password=" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    local -ag AVAX_ENDPOINTS=() ;
    get_endpoints AVAX_ENDPOINTS ;
    while getopts ":hSVYH:e:p:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            e|endpoint)
                local i; i="$(next_index AVAX_ENDPOINTS)" ;
                AVAX_ENDPOINTS["$i"]="${OPTARG}" ;;
            p|password)
                AVAX_AUTH_PASSWORD="${OPTARG}" ;;
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
    if [ -z "${AVAX_ENDPOINTS[*]}" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_AUTH_PASSWORD" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_NODE" ] ; then
        AVAX_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}

function get_endpoints {
    environ_vars "$1" "AVAX_ENDPOINT_([0-9]+)" "${!AVAX_ENDPOINT_@}" ;
}

function rpc_method {
    printf "auth.newToken" ;
}

function rpc_params {
    printf '{' ;
    printf '"endpoints":[' ; # shellcheck disable=SC2046
    join_by ',' $(map_by '"%s" ' "${AVAX_ENDPOINTS[@]}") ;
    printf '],' ;
    printf '"password":"%s"' "$AVAX_AUTH_PASSWORD" ;
    printf '}' ;
}

###############################################################################

cli "$@" && rpc_post "$AVAX_NODE/ext/auth" "$(rpc_data)" ;

###############################################################################
###############################################################################
