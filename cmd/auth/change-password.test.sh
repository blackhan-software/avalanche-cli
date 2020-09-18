#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh auth change-password" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/auth'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"auth.changePassword",' ;
    expect_d+='"params":{' ;
    expect_d+='"oldPassword":"OLD_PASSWORD",' ;
    expect_d+='"newPassword":"NEW_PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_auth__change_password_1a {
    check "$(AVAX_ID_RPC=1 \
        $(cmd) -p OLD_PASSWORD -n NEW_PASSWORD)" ;
}

function test_auth__change_password_1b {
    check "$(AVAX_ID_RPC=1 \
        AVAX_OLD_PASSWORD=OLD_PASSWORD $(cmd) -n NEW_PASSWORD)" ;
}

function test_auth__change_password_1c {
    check "$(AVAX_ID_RPC=1 \
        AVAX_NEW_PASSWORD=NEW_PASSWORD $(cmd) -p OLD_PASSWORD)" ;
}

###############################################################################
###############################################################################
