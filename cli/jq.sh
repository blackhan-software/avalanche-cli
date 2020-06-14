#!/usr/bin/env bash
###############################################################################

function jq {
    local string="\"${1:1}\":[[:space:]]*\"([^\"]+)\"" ;
    local number="\"${1:1}\":[[:space:]]*([[:digit:]]+)" ;
    local tokens="\"${1:1}\":[[:space:]]*(true|false|null)" ;
    while read -r line ; do
        [[ "$line" =~ $string ]] && printf '%s' "${BASH_REMATCH[1]}" && break ;
        [[ "$line" =~ $number ]] && printf '%s' "${BASH_REMATCH[1]}" && break ;
        [[ "$line" =~ $tokens ]] && printf '%s' "${BASH_REMATCH[1]}" && break ;
    done ;
}

###############################################################################
###############################################################################
