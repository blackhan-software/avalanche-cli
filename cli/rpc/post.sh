#!/usr/bin/env bash
###############################################################################

function rpc_post {
    local mime="${3-content-type:application/json}" ;
    local args="--url '${1}' --header '${mime}' --data '${2}'" ;
    if (( ${#AVAX_ARGS_RPC} > 0 )) ; then
        args="${args} ${AVAX_ARGS_RPC[*]}" ;
    fi
    if [ "$AVAX_SILENT_RPC" == "1" ] ; then
        args="${args} --silent" ;
    fi
    if [ "$AVAX_VERBOSE_RPC" == "1" ] ; then
        args="${args} --verbose" ;
    fi
    if [ "$AVAX_YES_RUN_RPC" != "1" ] ; then
        if [ "$AVAX_DEBUG_RPC" != "1" ] ; then
            printf '%s %s\n' "curl" "${args}" \
                | sed 's/"password":"[^"]*"/"password":"…"/g' ;
        else
            printf '%s %s\n' "curl" "${args}" ;
        fi
    else
        if [ -n "$AVAX_PIPE_RPC" ] ; then
            eval "$AVAX_PIPE_RPC" ;
        fi
        if [ -n "${AVAX_PIPE_RPC[*]}" ] ; then
            if [ -n "${AVAX_PIPE_RPC[$mime]}" ] ; then
                eval curl "${args}" | ${AVAX_PIPE_RPC[$mime]} ;
            else
                eval curl "${args}" ;
            fi
        else
            eval curl "${args}" ;
        fi
    fi
}

###############################################################################
###############################################################################
