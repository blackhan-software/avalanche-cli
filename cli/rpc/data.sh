#!/usr/bin/env bash
###############################################################################

function rpc_data {
    printf '{' ;
    printf '"jsonrpc":"2.0",' ;
    printf '"id":%s,' "$(rpc_id)" ;
    printf '"method":"%s",' "$(rpc_method)" ;
    printf '"params":%s' "$(rpc_params)" ;
    printf '}' ;
}

function rpc_id {
    printf '%d' "${RPC_ID-$RANDOM}" ;
}

function rpc_method {
    printf '%s' "$0: rpc_method: command not found" >&2 && exit 1 ;
}

function rpc_params {
    printf '%s' "$0: rpc_params: command not found" >&2 && exit 1 ;
}

###############################################################################
###############################################################################
