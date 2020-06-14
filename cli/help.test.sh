#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034
###############################################################################
CLI_TEST_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

source "$CLI_TEST_SCRIPT/help.sh" ;

###############################################################################

function test_command_help {
    assertNotNull "$(cli_help)" ;
}

function test_command_help_admin {
    local text; text="$(cli_help admin)" ;
    assertContains "$text" "Admin API" ;
    assertNotContains "$text" "AVM (X-Chain) API" ;
}

function test_command_help_avm {
    local text; text="$(cli_help avm)" ;
    assertContains "$text" "AVM (X-Chain) API" ;
    assertNotContains "$text" "EVM API" ;
}

function test_command_help_evm {
    local text; text="$(cli_help evm)" ;
    assertContains "$text" "EVM API" ;
    assertNotContains "$text" "Health API" ;
}

function test_command_help_health {
    local text; text="$(cli_help health)" ;
    assertContains "$text" "Health API" ;
    assertNotContains "$text" "Info API" ;
}

function test_command_help_info {
    local text; text="$(cli_help info)" ;
    assertContains "$text" "Info API" ;
    assertNotContains "$text" "IPC API" ;
}

function test_command_help_ipcs {
    local text; text="$(cli_help ipcs)" ;
    assertContains "$text" "IPC API" ;
    assertNotContains "$text" "Keystore API" ;
}

function test_command_help_keystore {
    local text; text="$(cli_help keystore)" ;
    assertContains "$text" "Keystore API" ;
    assertNotContains "$text" "Metrics API" ;
}

function test_command_help_metrics {
    local text; text="$(cli_help metrics)" ;
    assertContains "$text" "Metrics API" ;
    assertNotContains "$text" "Platform API" ;
}

function test_command_help_platform {
    local text; text="$(cli_help platform)" ;
    assertContains "$text" "Platform API" ;
    assertNotContains "$text" "Timestamp API" ;
}

function test_command_help_timestamp {
    local text; text="$(cli_help timestamp)" ;
    assertContains "$text" "Timestamp API" ;
    assertNotContains "$text" "Admin API" ;
}

###############################################################################
###############################################################################
