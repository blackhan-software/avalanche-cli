#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh wallet send-multiple" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/bc/${2-X}/wallet'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"wallet.sendMultiple",' ;
    expect_d+='"params":{' ;
    expect_d+='"outputs":[{' ;
    expect_d+='"assetID":"ASSET_ID",' ;
    expect_d+='"amount":1000,' ;
    expect_d+='"to":"TO"' ;
    expect_d+='}],' ;
    expect_d+='"from":["A1","A2"],' ;
    expect_d+='"changeAddr":"A3",' ;
    expect_d+='"memo":"MEMO",' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_wallet__send_1 {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -a ASSET_ID -# 1K -@ TO -f A1 -f A2 -c A3 -m MEMO \
        -u USERNAME -p PASSWORD)" ;
}

function test_wallet__send_2a {
    check "$(AVAX_ID_RPC=1 AVAX_OUTPUT_ASSET_ID_0=ASSET_ID $(cmd) \
        -# 1K -@ TO -f A1 -f A2 -c A3 -m MEMO \
        -u USERNAME -p PASSWORD)" ;
}

function test_wallet__send_2b {
    check "$(AVAX_ID_RPC=1 AVAX_OUTPUT_AMOUNT_0=1K $(cmd) \
        -a ASSET_ID -@ TO -f A1 -f A2 -c A3 -m MEMO \
        -u USERNAME -p PASSWORD)" ;
}

function test_wallet__send_2c {
    check "$(AVAX_ID_RPC=1 AVAX_OUTPUT_TO_0=TO $(cmd) \
        -a ASSET_ID -# 1K -f A1 -f A2 -c A3 -m MEMO \
        -u USERNAME -p PASSWORD)" ;
}

function test_wallet__send_3 {
    check "$(AVAX_ID_RPC=1 AVAX_MEMO=MEMO $(cmd) \
        -a ASSET_ID -# 1K -@ TO -f A1 -f A2 -c A3 \
        -u USERNAME -p PASSWORD)" ;
}

function test_wallet__send_4a {
    check "$(AVAX_ID_RPC=1 AVAX_USERNAME=USERNAME $(cmd) \
        -a ASSET_ID -# 1K -@ TO -f A1 -f A2 -c A3 -m MEMO \
        -p PASSWORD)" ;
}

function test_wallet__send_4b {
    check "$(AVAX_ID_RPC=1 AVAX_PASSWORD=PASSWORD $(cmd) \
        -a ASSET_ID -# 1K -@ TO -f A1 -f A2 -c A3 -m MEMO \
        -u USERNAME)" ;
}

function test_wallet__send_5a {
    check "$(AVAX_ID_RPC=1 AVAX_FROM_ADDRESS_0=A1 AVAX_FROM_ADDRESS_1=A2 \
        $(cmd) -a ASSET_ID -# 1K -@ TO -c A3 -m MEMO \
        -u USERNAME -p PASSWORD)" ;
}

function test_wallet__send_5b {
    check "$(AVAX_ID_RPC=1 AVAX_CHANGE_ADDRESS=A3 \
        $(cmd) -a ASSET_ID -# 1K -@ TO -f A1 -f A2 -m MEMO \
        -u USERNAME -p PASSWORD)" ;
}

function test_wallet__send_6a {
    check "$(AVAX_ID_RPC=1 $(cmd) \
        -a ASSET_ID -# 1K -@ TO -f A1 -f A2 -c A3 -m MEMO -u USERNAME \
        -p PASSWORD -b BC_ID)" BC_ID ;
}

function test_wallet__send_6b {
    check "$(AVAX_ID_RPC=1 AVAX_BLOCKCHAIN_ID=BC_ID $(cmd) \
        -a ASSET_ID -# 1K -@ TO -f A1 -f A2 -c A3 -m MEMO -u USERNAME \
        -p PASSWORD)" BC_ID ;
}

###############################################################################
###############################################################################
