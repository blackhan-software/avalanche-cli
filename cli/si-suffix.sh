#!/usr/bin/env bash
###############################################################################

function si {
    local number_rx="([[:digit:]]+)[EPTGMK]?" ;
    local number; number="$(\
        [[ "$1" =~ $number_rx ]] && printf '%s' "${BASH_REMATCH[1]}")" ;
    local metric_rx="[[:digit:]]+([EPTGMK]?)" ;
    local metric; metric="$(\
        [[ "$1" =~ $metric_rx ]] && printf '%s' "${BASH_REMATCH[1]}")" ;
    if [ -n "$number" ] ; then case "$metric" in
        E) printf '%s000000000000000000' "$number" ;;
        P) printf '%s000000000000000' "$number" ;;
        T) printf '%s000000000000' "$number" ;;
        G) printf '%s000000000' "$number" ;;
        M) printf '%s000000' "$number" ;;
        K) printf '%s000' "$number" ;;
        *) printf '%s' "$number" ;;
    esac
    else
        printf '0' ;
    fi
}

###############################################################################
###############################################################################
