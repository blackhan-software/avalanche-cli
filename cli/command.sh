#!/usr/bin/env bash
###############################################################################

##
## command_fqn './path/to/cmd/sub.sh' => cmd sub
## command_fqn 'path/to/cmd/sub.sh' => cmd sub
## command_fqn './sub.sh' => ./sub.sh
## command_fqn 'sub.sh' => sub.sh
##
function command_fqn {
    local cmd ;
    cmd=$([[ "$1" =~ ([^/]+)/([^/]+)\.sh$ ]] && printf '%s' "${BASH_REMATCH[1]}") ;
    local sub ;
    sub=$([[ "$1" =~ ([^/]+)\.sh$ ]] && printf '%s' "${BASH_REMATCH[1]}") ;
    if [[ -n "$cmd" ]] && [[ "$cmd" != '.' ]] ; then
        printf "%s %s" "$cmd" "$sub" ;
    else
        printf '%s' "$1" ;
    fi ;
}

###############################################################################
###############################################################################
