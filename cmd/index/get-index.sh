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
    usage+=" [-c|--container-id=\${AVAX_CONTAINER_ID}]" ;
    usage+=" [-e|--encoding=\${AVAX_ENCODING-cb58}]" ;
    usage+=" [-b|--blockchain-id=\${AVAX_BLOCKCHAIN_ID-X}]" ;
    usage+=" [-n|--index-name=\${AVAX_INDEX_NAME-tx|block}]" ;
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
    options+=( "-c" "--container-id=" ) ;
    options+=( "-e" "--encoding=" "--encoding=cb58" "--encoding=hex" ) ;
    options+=( "-b" "--blockchain-id=" "--blockchain-id=X" "--blockchain-id=P" "--blockchain-id=C" ) ;
    options+=( "-n" "--index-name=" "--index-name=tx" "--index-name=vtx" "--index-name=block" ) ;
    options+=( "-N" "--node=" ) ;
    options+=( "-S" "--silent-rpc" ) ;
    options+=( "-V" "--verbose-rpc" ) ;
    options+=( "-Y" "--yes-run-rpc" ) ;
    options+=( "-h" "--help" ) ;
    printf '%s ' "${options[@]}" ;
}

function cli {
    while getopts ":hSVYN:c:e:b:n:-:" OPT "$@"
    do
        if [ "$OPT" = "-" ] ; then
            OPT="${OPTARG%%=*}" ;
            OPTARG="${OPTARG#$OPT}" ;
            OPTARG="${OPTARG#=}" ;
        fi
        case "${OPT}" in
            list-options)
                cli_options && exit 0 ;;
            c|container-id)
                AVAX_CONTAINER_ID="${OPTARG}" ;;
            e|encoding)
                AVAX_ENCODING="${OPTARG}" ;;
            b|blockchain-id)
                AVAX_BLOCKCHAIN_ID="${OPTARG}" ;;
            n|index-name)
                AVAX_INDEX_NAME="${OPTARG}" ;;
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
    if [ -z "$AVAX_CONTAINER_ID" ] ; then
        cli_help && exit 1 ;
    fi
    if [ -z "$AVAX_ENCODING" ] ; then
        AVAX_ENCODING="cb58" ;
    fi
    if [ -z "$AVAX_BLOCKCHAIN_ID" ] ; then
        AVAX_BLOCKCHAIN_ID="X" ;
    fi
    if [ -z "$AVAX_INDEX_NAME" ] ; then
        if [ "$AVAX_BLOCKCHAIN_ID" == "P" ] ; then
            AVAX_INDEX_NAME="block" ;
        elif [ "$AVAX_BLOCKCHAIN_ID" == "C" ] ; then
            AVAX_INDEX_NAME="block" ;
        else
            AVAX_INDEX_NAME="tx" ;
        fi
    fi
    if [ -z "$AVAX_NODE" ] ; then
        AVAX_NODE="https://api.avax.network" ;
    fi
    shift $((OPTIND-1)) ;
}

function rpc_method {
    printf "index.getIndex" ;
}

function rpc_params {
    printf '{' ;
    printf '"containerID":"%s",' "$AVAX_CONTAINER_ID" ;
    printf '"encoding":"%s"' "$AVAX_ENCODING" ;
    printf '}' ;
}

###############################################################################

cli "$@" && rpc_post \
    "$AVAX_NODE/ext/index/$AVAX_BLOCKCHAIN_ID/$AVAX_INDEX_NAME" "$(rpc_data)" ;

###############################################################################
###############################################################################
