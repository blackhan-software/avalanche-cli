#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2091
###############################################################################
EVM_TEST=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$EVM_TEST/../../cli/array.sh" ;

###############################################################################
###############################################################################

function cmd {
    printf "./avalanche-cli.sh evm %s" "$(sub_command)" ;
}

function check {
    local result="$1" ; shift; printf '%s %s\n' "$(cmd)" "$(sub_args "$@")" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/bc/C/rpc'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"'"$(rpc_method)"'",' ;
    expect_d+='"params":[' ;
    expect_d+="$(rpc_params "$@")" ;
    expect_d+="]}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_evm__any_0 {
    cd "$EVM_TEST/../.." && check "$(AVAX_ID_RPC=1 $(cmd))" ;
}

function test_evm__any_1a {
    cd "$EVM_TEST/../.." && check "$(AVAX_ID_RPC=1 $(cmd) -P p1)" "p1" ;
}

function test_evm__any_1b {
    cd "$EVM_TEST/../.." && check "$(AVAX_ID_RPC=1 \
        AVAX_PARAMETER_0=p1 $(cmd))" "p1" ;
}

function test_evm__any_2a {
    cd "$EVM_TEST/../.." && check "$(AVAX_ID_RPC=1 \
        $(cmd) -P p1 -P p2)" "p1 p2" ;
}

function test_evm__any_2b {
    cd "$EVM_TEST/../.." && check "$(AVAX_ID_RPC=1 \
        AVAX_PARAMETER_0=p1 AVAX_PARAMETER_1=p2 $(cmd))" "p1 p2" ;
}

###############################################################################
###############################################################################

function sub_command {
    local script="${BASH_SOURCE[0]}" ;
    script="${script##*/}" ;
    script="${script%.*}" ;
    script="${script%.*}" ;
    printf '%s' "$script" ;
}

function sub_args {
    IFS=" " read -ra a <<< "$1" ;
    map_by '-P %s ' "${a[@]}" ;
}

function rpc_method {
    IFS="-" read -ra a <<< "$(sub_command)" ;
    printf '%s_%s%s' "${a[0]}" "${a[1]}" "$(for word in "${a[@]:2}" ; do
        printf '%s' "${word^}" ;
    done)" ;
}

function rpc_params {
    IFS=" " read -ra a <<< "$1" ; # shellcheck disable=SC2046
    join_by ',' $(map_by '%s ' "${a[@]}") ;
}

###############################################################################
###############################################################################
