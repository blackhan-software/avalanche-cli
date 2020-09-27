#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh avm create-fixed-cap-asset" ;
}

function check {
    local result="$1" ;
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
    expect_d+='"method":"avm.createFixedCapAsset",' ;
    expect_d+='"params":{' ;
    expect_d+='"name":"NAME",' ;
    expect_d+='"symbol":"SYMBOL",' ;
    expect_d+='"denomination":0,' ;
    expect_d+='"initialHolders":[' ;
    expect_d+='{"address":"A1","amount":1000000000},' ;
    expect_d+='{"address":"A2","amount":2000000000000}' ;
    expect_d+='],' ;
    expect_d+='"from":["A1","A2"],' ;
    expect_d+='"changeAddr":"A3",' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_avm__create_fixed_cap_asset_1a {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -@ A1 -# 1G -@ A2 -# 2T -f A1 -f A2 -c A3)" ;
}

function test_avm__create_fixed_cap_asset_1b {
    check "$(AVAX_ID_RPC=1 AVAX_NAME=NAME $(cmd) \
        -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -@ A1 -# 1G -@ A2 -# 2T -f A1 -f A2 -c A3)" ;
}

function test_avm__create_fixed_cap_asset_1c {
    check "$(AVAX_ID_RPC=1 AVAX_SYMBOL=SYMBOL $(cmd) \
        -n NAME -d 0 -u USERNAME -p PASSWORD \
        -@ A1 -# 1G -@ A2 -# 2T -f A1 -f A2 -c A3)" ;
}

function test_avm__create_fixed_cap_asset_1d {
    check "$(AVAX_ID_RPC=1 AVAX_DENOMINATION=0 $(cmd) \
        -n NAME -s SYMBOL -u USERNAME -p PASSWORD \
        -@ A1 -# 1G -@ A2 -# 2T -f A1 -f A2 -c A3)" ;
}

function test_avm__create_fixed_cap_asset_1e {
    check "$(AVAX_ID_RPC=1 AVAX_USERNAME=USERNAME $(cmd) \
        -n NAME -s SYMBOL -d 0 -p PASSWORD \
        -@ A1 -# 1G -@ A2 -# 2T -f A1 -f A2 -c A3)" ;
}

function test_avm__create_fixed_cap_asset_1f {
    check "$(AVAX_ID_RPC=1 AVAX_PASSWORD=PASSWORD $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME \
        -@ A1 -# 1G -@ A2 -# 2T -f A1 -f A2 -c A3)" ;
}

function test_avm__create_fixed_cap_asset_2a {
    check "$(AVAX_ID_RPC=1 AVAX_ADDRESS_0=A1 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -# 1G -@ A2 -# 2T -f A1 -f A2 -c A3)" ;
}

function test_avm__create_fixed_cap_asset_2b {
    check "$(AVAX_ID_RPC=1 AVAX_ADDRESS_0=A1 AVAX_ADDRESS_1=A2 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -# 1G -# 2T -f A1 -f A2 -c A3)" ;
}

function test_avm__create_fixed_cap_asset_3a {
    check "$(AVAX_ID_RPC=1 AVAX_AMOUNT_0=1G $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -@ A1 -@ A2 -# 2T -f A1 -f A2 -c A3)" ;
}

function test_avm__create_fixed_cap_asset_3b {
    check "$(AVAX_ID_RPC=1 AVAX_AMOUNT_0=1G AVAX_AMOUNT_1=2T $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -@ A1 -@ A2 -f A1 -f A2 -c A3)" ;
}

function test_avm__create_fixed_cap_asset_4a {
    check "$(AVAX_ID_RPC=1 AVAX_AMOUNT_0=1G \
        AVAX_FROM_ADDRESS_0=A1 AVAX_FROM_ADDRESS_1=A2 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -@ A1 -@ A2 -# 2T -c A3)" ;
}

function test_avm__create_fixed_cap_asset_4b {
    check "$(AVAX_ID_RPC=1 AVAX_AMOUNT_0=1G \
        AVAX_CHANGE_ADDRESS=A3 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -@ A1 -@ A2 -# 2T -f A1 -f A2)" ;
}

function test_avm__create_fixed_cap_asset_5a {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -@ A1 -# 1G -@ A2 -# 2T  -f A1 -f A2 -c A3 \
        -b BC_ID)" BC_ID ;
}

function test_avm__create_fixed_cap_asset_5b {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=BC_ID $(cmd) \
        -n NAME -s SYMBOL -d 0 -u USERNAME -p PASSWORD \
        -@ A1 -# 1G -@ A2 -# 2T  -f A1 -f A2 -c A3 \
        -b BC_ID)" BC_ID ;
}

###############################################################################
###############################################################################
