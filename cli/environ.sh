#!/usr/bin/env bash
# shellcheck disable=SC2034
###############################################################################

##
## environ_vars array "VAR_PREFIX_([0-9]+)" "${!VAR_PREFIX_@}" => array=( .. )
## environ_vars array "VAR_([0-9]+)_SUFFIX" "${!VAR_@_SUFFIX}" => array=( .. )
##
function environ_vars {
    local -n var_array="$1" ; shift ;
    local var_regex="$1" ; shift ;
    for var_name in "$@" ; do
        if [[ "$var_name" =~ ${var_regex} ]] ; then
            local var_value ; eval var_value="\$$var_name" ;
            var_array["${BASH_REMATCH[1]}"]="$var_value" ;
        fi
    done
}

###############################################################################
###############################################################################
