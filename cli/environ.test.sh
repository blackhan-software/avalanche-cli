#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034,SC2153
###############################################################################
CLI_TEST_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CLI_TEST_SCRIPT/environ.sh" ;

###############################################################################

function test_environ_vars_nil {
    local -a MY ;
    environ_vars MY "MY_([0-9]+)" "${!MY_@}" ;
    assertEquals "" "${MY[*]}" ;
}

function test_environ_vars_0ZZ {
    local -a MY ; local MY_0="_" ;
    environ_vars MY "MY_([0-9]+)" "${!MY_@}" ;
    assertEquals "0" "${!MY[*]}" ;
    assertEquals "_" "${MY[*]}" ;
}

function test_environ_vars_Z1Z {
    local -a MY ; local MY_1="A" ;
    environ_vars MY "MY_([0-9]+)" "${!MY_@}" ;
    assertEquals "1" "${!MY[*]}" ;
    assertEquals "A" "${MY[1]}" ;
}

function test_environ_vars_ZZ2 {
    local -a MY ; local MY_2="B" ;
    environ_vars MY "MY_([0-9]+)" "${!MY_@}" ;
    assertEquals "2" "${!MY[*]}" ;
    assertEquals "B" "${MY[2]}" ;
}

function test_environ_vars_012 {
    local -a MY ; local MY_0="_" MY_1="A" MY_2="B" ;
    environ_vars MY "MY_([0-9]+)" "${!MY_@}" ;
    assertEquals "0 1 2" "${!MY[*]}" ;
    assertEquals "_ A B" "${MY[*]}" ;
}

function test_environ_vars_01Z {
    local -a MY ; local MY_0="_" MY_1="A" ;
    environ_vars MY "MY_([0-9]+)" "${!MY_@}" ;
    assertEquals "0 1" "${!MY[*]}" ;
    assertEquals "_ A" "${MY[*]}" ;
}

function test_environ_vars_0Z2 {
    local -a MY ; local MY_0="_" MY_2="B" ;
    environ_vars MY "MY_([0-9]+)" "${!MY_@}" ;
    assertEquals "0 2" "${!MY[*]}" ;
    assertEquals "_ B" "${MY[*]}" ;
}

function test_environ_vars_Z12 {
    local -a MY ; local MY_1="A" MY_2="B" ;
    environ_vars MY "MY_([0-9]+)" "${!MY_@}" ;
    assertEquals "1 2" "${!MY[*]}" ;
    assertEquals "A B" "${MY[*]}" ;
}

###############################################################################
###############################################################################
