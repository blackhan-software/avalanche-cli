#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2214,SC2231
###############################################################################
CLI=$(dirname "${BASH_SOURCE[0]}")/$(dirname "$(readlink "${BASH_SOURCE[0]}")")
CLI=$(cd "$CLI" >/dev/null 2>&1 && pwd)
###############################################################################

function cli {
    local cmd="$2" ;
    local sub="$3" ;
    while getopts ":hv-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-commands) cli_supcommands && exit 0 ;;
            list-options) cli_supoptions && exit 0 ;;
            v|version) printf '%s\n' "$(cli_version)" && exit 0 ;;
            h|help) cli_usage "$cmd" "$sub" && exit 0 ;;
            :|*) cli_usage && exit 1 ;;
        esac
    done
    shift $((OPTIND-1)) ;
    cli_run "$@" ;
}

function cli_run {
    local cmd="$1" ;
    local cmd_path="$CLI/cmd/$cmd" ;
    local sub="$2" ;
    local sub_path="$CLI/cmd/$cmd/$sub.sh" ;
    if [ -d "$cmd_path" ] ; then
        if [ -f "$sub_path" ] ; then
            exec "$sub_path" "${@:3}" ;
        else
            while getopts ":h-:" OPT "${@:2}"
            do
                if [ "$OPT" = "-" ] ; then
                    OPT="${OPTARG%%=*}" ;
                    OPTARG="${OPTARG#$OPT}" ;
                    OPTARG="${OPTARG#=}" ;
                fi
                case "${OPT}" in
                    list-commands) cli_subcommands "$cmd" && exit 0 ;;
                    list-options) cli_suboptions "$cmd" && exit 0 ;;
                    h|help) cli_usage "$cmd" && exit 0 ;;
                    :|*) cli_usage "$cmd" && exit 1 ;;
                esac
            done
            shift $((OPTIND-1)) ;
            cli_usage "$cmd" && exit 1 ;
        fi
    else
        cli_usage && exit 1 ;
    fi
}

function cli_supoptions {
    printf '%s' '-h --help -v --version' ;
}

function cli_supcommands {
    for path in $CLI/cmd/* ; do
        path="${path##*/}" ;
        printf '%s ' "$path" ;
    done
    printf '\n' ;
}

function cli_suboptions {
    printf '%s' '-h --help' ;
}

function cli_subcommands {
    for path in $CLI/cmd/"$1"/*.sh ; do
        if [[ ! "$path" =~ \.test\.sh$ ]] ; then
            path="${path##*/}" ;
            path="${path%.*}" ;
            printf '%s ' "$path" ;
        fi
    done
    printf '\n' ;
}

function cli_usage {
    source "$CLI/cli/help.sh" && \
        printf '%s\n' "$(cli_help "$1" "$2")" ;
}

function cli_version {
    source "$CLI/cli/jq.sh" && \
        jq ".version" < "$CLI/package.json" ;
}

###############################################################################

cli "$@" ;

###############################################################################
###############################################################################
