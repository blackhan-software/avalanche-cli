#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034
###############################################################################
CLI_TEST_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CLI_TEST_SCRIPT/command.sh" ;

###############################################################################

function test_command_name_1 {
    assertEquals "cmd sub" "$(command_fqn './path/to/cmd/sub.sh')" ;
}

function test_command_name_2 {
    assertEquals "cmd sub" "$(command_fqn 'path/to/cmd/sub.sh')" ;
}

function test_command_name_3 {
    assertEquals "./sub.sh" "$(command_fqn './sub.sh')" ;
}

function test_command_name_4 {
    assertEquals "sub.sh" "$(command_fqn 'sub.sh')" ;
}

###############################################################################
###############################################################################
