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
    usage+=" [-P|--parameter=\${AVA_PARAMETER_\$IDX}]*" ;
    usage+=" [-N|--node=\${AVA_NODE-127.0.0.1:9650}]" ;
    usage+=" [-S|--silent-rpc|\${AVA_SILENT_RPC}]" ;
    usage+=" [-V|--verbose-rpc|\${AVA_VERBOSE_RPC}]" ;
    usage+=" [-Y|--yes-run-rpc|\${AVA_YES_RUN_RPC}]" ;
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
    local -ag AVA_PARAMETERS=() ;
    get_parameters AVA_PARAMETERS ;
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
                local i; i="$(next_index AVA_PARAMETERS)" ;
                AVA_PARAMETERS["$i"]="${OPTARG}" ;;
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
    if [ -z "${AVA_PARAMETERS[*]}" ] ; then
        AVA_PARAMETERS=() ;
    fi
    if [ -z "$AVA_NODE" ] ; then
        AVA_NODE="127.0.0.1:9650" ;
    fi
    shift $((OPTIND-1)) ;
}

function get_parameters {
    environ_vars "$1" "AVA_PARAMETER_([0-9]+)" "${!AVA_PARAMETER_@}" ;
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
    join_by ',' $(map_by '"%s" ' "${AVA_PARAMETERS[@]}") ;
    printf ']' ;
}

###############################################################################

cli "$@" && rpc_post "$AVA_NODE/ext/bc/C/rpc" "$(rpc_data)" ;

###############################################################################
###############################################################################
