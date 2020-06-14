#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2059,SC2178,SC2207
###############################################################################

##
## map_by '"%s" ' ( a b c ) => "a" "b" "c"
##
function map_by {
    local format="$1" ; shift ;
    if ((${#@}>0)) ; then
        printf -- "$format" "${@}" ;
    fi
}

##
## join_by ', ' ( a b c ) => a, b, c
##
function join_by {
    local delimiter="$1" ; shift ;
    if ((${#@}>0)) ; then
        printf -- '%s' "$1" ; shift ; printf '%s' "${@/#/$delimiter}" ;
    fi
}

##
## zip_by '"%s":"%s" ' ( a b c ) ( x y z ) => "a":"x" "b":"y" "c":"z"
## zip_by '"%s":"%s" ' ( a b c ) ( x y   ) => "a":"x" "b":"y" "c":"" [ok]
## zip_by '"%s":"%s" ' ( a b   ) ( x y z ) => "a":"y" "b":"z" "x":"" [!!]
##
function zip_by {
    local delimiter="$1" ; shift ;
    local length=$((("${#@}"+1)/2)) ;
    local -a lhs_array=("${@:1:$length}") ;
    shift "$length" ; ## assume ${#lhs_array}==${#rhs_array}[+1]
    local -a rhs_array=("${@:1:$length}") ;
    for i in "${!lhs_array[@]}" ; do
        printf -- "$delimiter" "${lhs_array[$i]}" "${rhs_array[$i]}" ;
    done
}

##
## zip_by_n '"%s":"%s"' 3 ( a b c ) 2 ( x y   ) => "a":"x" "b":"y" "c":""
## zip_by_n '"%s":"%s"' 2 ( a b   ) 3 ( x y z ) => "a":"x" "b":"y" "":"z"
##
function zip_by_n {
    local delimiter="$1" ; shift ;
    local lhs_length="$1" ; shift ;
    local -a lhs_array=("${@:1:$lhs_length}") ; shift "$lhs_length" ;
    local rhs_length="$1" ; shift ;
    local -a rhs_array=("${@:1:$rhs_length}") ; shift "$rhs_length" ;
    if (( "${#lhs_array[@]}" >= "${#rhs_array[@]}" )) ; then
        for i in "${!lhs_array[@]}" ; do
            printf -- "$delimiter" "${lhs_array[$i]}" "${rhs_array[$i]}" ;
        done
    else
        for i in "${!rhs_array[@]}" ; do
            printf -- "$delimiter" "${lhs_array[$i]}" "${rhs_array[$i]}" ;
        done
    fi
}

##
## next_index ( _ b c ) => 0
## next_index ( a _ c ) => 1
## next_index ( a b _ ) => 2
## next_index ( a b c ) => 3
##
function next_index {
    local -n array="$1" ;
    local empty_index=0 ;
    while true ; do
        if [ -z "${array["$empty_index"]}" ] ; then
            printf -- '%s' "$empty_index" ;
            return 0 ;
        else
            ((empty_index+=1)) ;
        fi
    done
}

###############################################################################
###############################################################################
