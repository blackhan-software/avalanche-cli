#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034
###############################################################################
CLI_TEST_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CLI_TEST_SCRIPT/jq.sh" ;

###############################################################################

function test_jq_1a {
    assertEquals "value" "$(jq ".string" <<< '{"string":"value"}')" ;
}

function test_jq_1b {
    assertEquals "value" "$(jq ".string" <<< '{
        "string": "value"
    }')" ;
}

function test_jq_2a {
    assertEquals "0" "$(jq ".number" <<< '{"number":0}')" ;
}

function test_jq_2b {
    assertEquals "0" "$(jq ".number" <<< '{
        "number": 0
    }')" ;
}

function test_jq_3a {
    assertEquals "true" "$(jq ".key" <<< '{"key":true}')" ;
}

function test_jq_3b {
    assertEquals "true" "$(jq ".key" <<< '{
        "key": true
    }')" ;
}

function test_jq_4a {
    assertEquals "false" "$(jq ".key" <<< '{"key":false}')" ;
}

function test_jq_4b {
    assertEquals "false" "$(jq ".key" <<< '{
        "key": false
    }')" ;
}

function test_jq_5a {
    assertEquals "null" "$(jq ".key" <<< '{"key":null}')" ;
}

function test_jq_5b {
    assertEquals "null" "$(jq ".key" <<< '{
        "key": null
    }')" ;
}

###############################################################################
###############################################################################
