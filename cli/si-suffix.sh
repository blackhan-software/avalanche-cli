#!/usr/bin/env bash
###############################################################################

function si {
    local number_rx="([[:digit:]]+)[YZEPTGMK]?" ;
    local number; number="$(\
        [[ "$1" =~ $number_rx ]] && printf '%s' "${BASH_REMATCH[1]}")"
    local metric_rx="[[:digit:]]+([YZEPTGMK]?)" ;
    local metric; metric="$(\
        [[ "$1" =~ $metric_rx ]] && printf '%s' "${BASH_REMATCH[1]}")"
    case "$metric" in
        Y) printf '%d000000000000000000000000' "$number" ;;
        Z) printf '%d000000000000000000000' "$number" ;;
        E) printf '%d000000000000000000' "$number" ;;
        P) printf '%d000000000000000' "$number" ;;
        T) printf '%d000000000000' "$number" ;;
        G) printf '%d000000000' "$number" ;;
        M) printf '%d000000' "$number" ;;
        K) printf '%d000' "$number" ;;
        *) printf '%d' "$number" ;;
    esac
}

###############################################################################
###############################################################################
