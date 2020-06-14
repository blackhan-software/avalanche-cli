#!/usr/bin/env bash
###############################################################################

function rpc_post {
    local mime="${3-content-type:application/json}" ;
    local args="--url '${1}' --header '${mime}' --data '${2}'" ;
    if [ "$AVA_SILENT_RPC" == "1" ] ; then
        args="${args} --silent" ;
    fi
    if [ "$AVA_VERBOSE_RPC" == "1" ] ; then
        args="${args} --verbose" ;
    fi
    if [ "$AVA_YES_RUN_RPC" != "1" ] ; then
        if [ "$AVA_DEBUG_RPC" != "1" ] ; then
            printf '%s %s\n' "curl" "${args}" \
                | sed 's/"password":"[^"]*"/"password":"…"/g' ;
        else
            printf '%s %s\n' "curl" "${args}" ;
        fi
    else
        eval curl "${args}" ;
    fi
}

###############################################################################
###############################################################################
