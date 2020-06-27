#!/usr/bin/env bash
###############################################################################

function jq {
    local string_rx="\"${1:1}\":[[:space:]]*\"([^\"]+)\"" ;
    local number_rx="\"${1:1}\":[[:space:]]*([[:digit:]]+)" ;
    local tokens_rx="\"${1:1}\":[[:space:]]*(true|false|null)" ;
    while read -r line ; do
        [[ "$line" =~ $string_rx ]] \
            && printf '%s' "${BASH_REMATCH[1]}" && break ;
        [[ "$line" =~ $number_rx ]] \
            && printf '%s' "${BASH_REMATCH[1]}" && break ;
        [[ "$line" =~ $tokens_rx ]] \
            && printf '%s' "${BASH_REMATCH[1]}" && break ;
    done ;
}

###############################################################################
###############################################################################
