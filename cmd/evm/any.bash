#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2153,SC2214
###############################################################################
EVM_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$EVM_SCRIPT/../../cli/array.sh" ;
source "$EVM_SCRIPT/../../cli/color.sh" ;
source "$EVM_SCRIPT/../../cli/command.sh" ;
source "$EVM_SCRIPT/../../cli/environ.sh" ;
source "$EVM_SCRIPT/../../cli/rpc/data.sh" ;
source "$EVM_SCRIPT/../../cli/rpc/post.sh" ;

###############################################################################
###############################################################################

function cli_help {
    local usage ;
    usage="${BB}Usage:${NB} $(command_fqn "${0}")" ;
    usage+=" [-P|--parameter=\${AVAX_PARAMETER_\$IDX}]*" ;
    usage+=" [-N|--node=\${AVAX_NODE-https://api.avax.network}]" ;
    usage+=" [-S|--silent-rpc|\${AVAX_SILENT_RPC}]" ;
    usage+=" [-V|--verbose-rpc|\${AVAX_VERBOSE_RPC}]" ;
    usage+=" [-Y|--yes-run-rpc|\${AVAX_YES_RUN_RPC}]" ;
    usage+=" [-h|--help]" ;
    source "$EVM_SCRIPT/../../cli/help.sh" ; # shellcheck disable=2046
    printf '%s\n\n%s\n' "$usage" "$(help_for $(command_fqn "${0}"))" ;
}

function cli_options {
    local -a options ;
    options+=( "-P" "--parameter=" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    local -ag AVAX_PARAMETERS=() ;
    get_parameters AVAX_PARAMETERS ;
    while getopts ":hSVYN:P:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            P|parameter)
                local i; i="$(next_index AVAX_PARAMETERS)" ;
                AVAX_PARAMETERS["$i"]="${OPTARG}" ;;
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
    if [ -z "${AVAX_PARAMETERS[*]}" ] ; then
        AVAX_PARAMETERS=() ;
    fi
    if [ -z "$AVAX_NODE" ] ; then
        AVAX_NODE="https://api.avax.network" ;
    fi
    shift $((OPTIND-1)) ;
}

function get_parameters {
    environ_vars "$1" "AVAX_PARAMETER_([0-9]+)" "${!AVAX_PARAMETER_@}" ;
}

function rpc_command {
    local script="${BASH_SOURCE[0]}" ;
    script="${script##*/}" ;
    script="${script%.*}" ;
    script="${script%.*}" ;
    printf '%s' "$script" ;
}

function rpc_method {
    IFS="-" read -ra a <<< "$(rpc_command)" ;
    printf '%s_%s%s' "${a[0]}" "${a[1]}" "$(for word in "${a[@]:2}" ; do
        printf '%s' "${word^}" ;
    done)"  ;
}

function rpc_params {
    printf '[' ; # shellcheck disable=SC2046
    join_by ',' $(map_by '%s ' "${AVAX_PARAMETERS[@]}") ;
    printf ']' ;
}

###############################################################################

cli "$@" && rpc_post "$AVAX_NODE/ext/bc/C/rpc" "$(rpc_data)" ;

###############################################################################
###############################################################################
