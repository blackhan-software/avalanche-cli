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
        Y) printf '%s000000000000000000000000' "$number" ;;
        Z) printf '%s000000000000000000000' "$number" ;;
        E) printf '%s000000000000000000' "$number" ;;
        P) printf '%s000000000000000' "$number" ;;
        T) printf '%s000000000000' "$number" ;;
        G) printf '%s000000000' "$number" ;;
        M) printf '%s000000' "$number" ;;
        K) printf '%s000' "$number" ;;
        *) printf '%s' "$number" ;;
    esac
}

###############################################################################
###############################################################################
