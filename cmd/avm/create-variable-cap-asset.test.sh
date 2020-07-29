#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh avm create-variable-cap-asset" ;
}

function check {
    local result="$1";
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/bc/${2-X}'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"avm.createVariableCapAsset",' ;
    expect_d+='"params":{' ;
    expect_d+='"name":"NAME",' ;
    expect_d+='"symbol":"SYMBOL",' ;
    expect_d+='"denomination":0,' ;
    expect_d+='"minterSets":[' ;
    expect_d+='{"minters":["A1"],"threshold":1},' ;
    expect_d+='{"minters":["B1","B2"],"threshold":2},' ;
    expect_d+='{"minters":["C1","C2","C3"],"threshold":3}' ;
    expect_d+='],' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_avm__create_variable_cap_asset_1a {
    check "$(AVA_ID_RPC=1 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -m A1 -t1 -m B1 -m B2 -t2 -m C1 -m C2 -m C3 -t3)" ;
}

function test_avm__create_variable_cap_asset_1b {
    check "$(AVA_ID_RPC=1 AVA_NAME=NAME $(cmd) \
        -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -m A1 -t1 -m B1 -m B2 -t2 -m C1 -m C2 -m C3 -t3)" ;
}

function test_avm__create_variable_cap_asset_1c {
    check "$(AVA_ID_RPC=1 AVA_SYMBOL=SYMBOL $(cmd) \
        -n NAME -d 0 -u USERNAME -p PASSWORD \
        -m A1 -t1 -m B1 -m B2 -t2 -m C1 -m C2 -m C3 -t3)" ;
}

function test_avm__create_variable_cap_asset_1d {
    check "$(AVA_ID_RPC=1 AVA_DENOMINATION=0 $(cmd) \
        -n NAME -s SYMBOL -u USERNAME -p PASSWORD \
        -m A1 -t1 -m B1 -m B2 -t2 -m C1 -m C2 -m C3 -t3)" ;
}

function test_avm__create_variable_cap_asset_1e {
    check "$(AVA_ID_RPC=1 AVA_USERNAME=USERNAME $(cmd) \
        -n NAME -s SYMBOL -d 0 -p PASSWORD \
        -m A1 -t1 -m B1 -m B2 -t2 -m C1 -m C2 -m C3 -t3)" ;
}

function test_avm__create_variable_cap_asset_1f {
    check "$(AVA_ID_RPC=1 AVA_PASSWORD=PASSWORD $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME \
        -m A1 -t1 -m B1 -m B2 -t2 -m C1 -m C2 -m C3 -t3)" ;
}

function test_avm__create_variable_cap_asset_2a {
    check "$(AVA_ID_RPC=1 \
        AVA_THRESHOLD_0=1 AVA_MINTERS_0=A1 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -m B1 -m B2 -t2 -m C1 -m C2 -m C3 -t3)" ;
}

function test_avm__create_variable_cap_asset_2b {
    check "$(AVA_ID_RPC=1 \
        AVA_MINTERS_1="B1 B2" AVA_THRESHOLD_1=2 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -m A1 -t1 -m C1 -m C2 -m C3 -t3)" ;
}

function test_avm__create_variable_cap_asset_2c {
    check "$(AVA_ID_RPC=1 \
        AVA_MINTERS_2="C1 C2 C3" AVA_THRESHOLD_2=3 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -m A1 -t1 -m B1 -m B2 -t2)" ;
}

function test_avm__create_variable_cap_asset_3 {
    check "$(AVA_ID_RPC=1 \
        AVA_MINTERS_0="A1" AVA_THRESHOLD_0=1 \
        AVA_MINTERS_1="B1 B2" AVA_THRESHOLD_1=2 \
        AVA_MINTERS_2="C1 C2 C3" AVA_THRESHOLD_2=3 \
        $(cmd) -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD)" ;
}

function test_avm__create_variable_cap_asset_4a {
    check "$(AVA_ID_RPC=1 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -m A1 -t1 -m B1 -m B2 -t2 -m C1 -m C2 -m C3 -t3 -b BC_ID)" BC_ID ;
}

function test_avm__create_variable_cap_asset_4b {
    check "$(AVA_ID_RPC=1 \
        AVA_BLOCKCHAIN_ID=BC_ID $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -m A1 -t1 -m B1 -m B2 -t2 -m C1 -m C2 -m C3 -t3)" BC_ID ;
}

###############################################################################
###############################################################################
