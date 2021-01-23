[![NPM version](https://badge.fury.io/js/avalanche-cli.svg)](https://npmjs.org/package/avalanche-cli)
[![Build Status](https://travis-ci.org/hsk81/avalanche-cli.svg?branch=master)](https://travis-ci.org/hsk81/avalanche-cli)

# A Command Line Interface for Avalanche APIs

```
Usage: avalanche-cli [OPTIONS] COMMMAND
```

## Options

```
-h --help         Show help information and quit.
-v --version      Print CLI version information and quit.
```

## Installation

First of all, it is possible to run `avalanche-cli` *without any installation* whatsoever, by simply invoking it via [`npx`] (aka the [`npm`] package executor):

```sh
$ npx avalanche-cli --help
```

But, if you decide to permanently install it via [`npm`], then do so with:

```sh
$ npm install avalanche-cli -g ## avoid `sudo` (see FAQ)
```

```sh
$ avalanche-cli -h ## show help info
```

Also, an installation via `npm` activates *command line completion* (i.e. hitting the TAB key after writing `avalanche-cli` should offer a list of available commands and options). Finally, for `avalanche-cli` to work properly your operating system needs to provide the dependencies below.

## Dependencies

```
Name            : curl
Version         : 7.73.0-1
Description     : An URL retrieval utility and library
```

```
Name            : zsh
Version         : 5.8-1
Description     : the Z shell
```

Or instead of `zsh`:
```
Name            : bash
Version         : 5.0.018-1
Description     : The GNU Bourne Again shell
```

Optional:
```
Name            : bash-completion
Version         : 2.11-1
Description     : Programmable completion for the bash shell
```

Only for installation (and for [`npx`]):
```
Name            : npm
Version         : 6.14.8-2
Description     : A package manager
```

## Usage

All CLI options of the `avalanche-cli` tool can also be set via environment variables. It assumes by default an [AVAX] node available at `127.0.0.1:9650` &ndash; although this can be changed by setting and exporting the `AVAX_NODE` variable *or* by using the corresponding `--node` (`-N`) option.

### User creation

Let's see how a new `keystore` user is created:

```sh
$ avalanche-cli keystore create-user -h
```
```
Usage: keystore create-user [-u|--username=${AVAX_USERNAME}] [-p|--password=${AVAX_PASSWORD}] [-N|--node=${AVAX_NODE-127.0.0.1:9650}] [-S|--silent-rpc|${AVAX_SILENT_RPC}] [-V|--verbose-rpc|${AVAX_VERBOSE_RPC}] [-Y|--yes-run-rpc|${AVAX_YES_RUN_RPC}] [-h|--help]
```

```sh
$ avalanche-cli keystore create-user -u MyUser -p MySecret-1453
```
```
curl --url '127.0.0.1:9650/ext/keystore' --header 'content-type:application/json' --data '{"jsonrpc":"2.0","id":3411,"method":"keystore.createUser","params":{"username":"MyUser","password":"…"}}'
```
By default, `avalanche-cli` does *not* run the command, but simply shows the corresponding `curl` request (without the `password`). If some parameter had been missing or unexpected, then the *usage* string would have been re-shown. To actually invoke the command the `-Y` option needs to be appended:

```sh
$ avalanche-cli keystore create-user -u MyUser -p MySecret-1453 -Y
```
```json
$ {"jsonrpc":"2.0","result":{"success":true},"id":21265}
```

Since most of the commands expect a username and a password, let's export them as environment variables, so they can be re-used:

```sh
$  export AVAX_USERNAME=MyUser AVAX_PASSWORD=MySecret-1453
```

Please note, that the line above starts with an *empty space* (`$__export AVAX_..`) to avoid the variables getting cached in the `bash` history! In general this is good practice when handling credentials via the CLI (but otherwise it is not required).

### User deletion

Let's delete the previously created user, where it is not required to provide the `-u` (`--username`) and `-p` (`--password`) options again, since the corresponding environment variables have been exported above:

```sh
$ avalanche-cli keystore delete-user
```
```
curl --url '127.0.0.1:9650/ext/keystore' --header 'content-type:application/json' --data '{"jsonrpc":"2.0","id":26347,"method":"keystore.deleteUser","params":{"username":"MyUser","password":"…"}}'
```

```sh
$ avalanche-cli keystore delete-user -Y
```
```json
{"jsonrpc":"2.0","result":{"success":true},"id":31641}
```

### JSON processing with [`jq`]

Since `avalance-cli` does not process any JSON reponses, it is recommended to use the excellent [`jq`] command line JSON processor to handle them. For example:

```sh
$ avalanche-cli info peers -YS | jq .result.peers[0]
```
```json
{
  "ip": "185.144.83.145:9651",
  "publicIP": "185.144.83.145:9651",
  "id": "F7qAwDMgFCJ1TG9U4sjFKeYNGKfbToGE5",
  "version": "avalanche/0.5.5",
  "lastSent": "2020-06-27T04:16:56+02:00",
  "lastReceived": "2020-06-27T04:16:38+02:00"
}
```
..where the `-S` (`--silent-rpc`) option tells the internal `curl` tool to not produce unnessary output, so we get the desired result from above. ;D

## Common Options

All commands share the following options and corresponding environment variables:

### `${AVAX_NODE-127.0.0.1:9650}` or `--node` (`-N`)

Can be used to set the [AVAX] node which the `avalanche-cli` tool will be communicating with &ndash; where the default is `127.0.0.1:9650`. For example:

```sh
$ avalanche-cli info peers -N=127.0.0.1:9650
```

```
$ avalanche-cli info peers --node=127.0.0.1:9650
```

```
$ AVAX_NODE=127.0.0.1:9650 avalanche-cli info peers
```

### `${AVAX_YES_RUN_RPC}` or `--yes-run-rpc` (`-Y`)

Can be used to actually execute the `curl` request the `avalanche-cli` tool puts together &ndash; where by default this is *off*, i.e. the corresponding `curl` request will only be shown but *not* executed. For example:

```sh
$ avalanche-cli info peers -Y
```

```sh
$ avalanche-cli info peers --yes-run-rpc
```

```sh
$ AVAX_YES_RUN_RPC=1 avalanche-cli info peers
```

### `${AVAX_SILENT_RPC}` or `--silent-rpc` (`-S`)

Can be used to make a `curl` request with its corresponding *silent* flag on &ndash; where by default it is *off*. However when *on*, this will *not* silence the actual response (if there is any):

```sh
$ avalanche-cli info peers -YS
```

```sh
$ avalanche-cli info peers -Y --silent-rpc
```

```sh
$ AVAX_SILENT_RPC=1 avalanche-cli info peers -Y
```

### `${AVAX_VERBOSE_RPC}` or `--verbose-rpc` (`-V`)

Can be used to make a `curl` request with its corresponding *verbose* flag on &ndash; where by default it is *off*. This is useful, if one wants to get a detailed view of an ongoing request:

```sh
$ avalanche-cli info peers -YV
```

```sh
$ avalanche-cli info peers -Y --verbose-rpc
```

```sh
$ AVAX_VERBOSE_RPC=1 avalanche-cli info peers -Y
```

## Common Variables

Further, almost all commands share the following &ndash; very general &ndash; environment variables:

### `${AVAX_ARGS_RPC}`

Can be used to make a `curl` request with a corresponding argument (or arguments). This is useful, since it allows to access all of `curl`'s capabilities. For example:

```sh
$ export AVAX_ARGS_RPC="--no-progress-meter" ## if supported by curl implementation
```

```sh
$ avalanche-cli info peers -Y
```

Now, *each* request will be performed without a progress meter (which can be distracting in case one chooses to pipe a response through another command).

### `${AVAX_PIPE_RPC}`

Can be used to pipe a `curl` response through a command, where `AVAX_PIPE_RPC` needs to be an (implicit) associative array with content types as keys and corresponding commands as value entries. For example:

```sh
$ export AVAX_PIPE_RPC="declare -A AVAX_PIPE_RPC=([content-type:application/json]='jq -c')"
```

```sh
$ avalanche-cli info peers -Y
```

Now, *each* `application/json` response will be compactified and colorized by using the [`jq`] command line JSON processor. Further, to temporarily omit piping through any command, (unset or) set `AVAX_PIPE_RPC` to an empty string:

```
$ AVAX_PIPE_RPC='' avalanche-cli info peers -Y
```

### [`${AVAX_AUTH_HEADER}`](https://docs.avax.network/v1.0/en/api/auth)

An authorization token provides access to one or more API endpoints. This is is useful for delegating access to a node's APIs. Tokens expire after 12 hours, but before that the token can be provided in the header of an API call. Specifically, the header `Authorization` should have the value `Bearer $TOKEN`. For example:

```sh
AVAX_AUTH_TOKEN=$(avalanche-cli auth new-token -p "$AVAX_AUTH_PASSWORD" -e '*' -Y | jq -r .result.token)
```

```sh
export AVAX_AUTH_HEADER="Bearer $AVAX_AUTH_TOKEN"
```

Any subsequent requests will have the `Authorization` header set to `Bearer $AVAX_AUTH_TOKEN`, after which &ndash; if desired &ndash; the header variable can be unset and the token be revoked with:

```sh
unset AVAX_AUTH_HEADER
```

```sh
avalanche-cli auth revoke-token -p "$AVAX_AUTH_PASSWORD" -t "$AVAX_AUTH_TOKEN" -Y
```

## FAQ

### Can I install as a regular user instead as `root`?

It is actually *recommended* to avoid an installion as `root` (or via `sudo`). Instead, setup [`npm`] to install packages globally (per user) *without* breaking out of the `$HOME` folder:

```sh
$ export PATH="$PATH:$HOME/.node/bin" ## *also* put this e.g. into ~/.bashrc
$ echo 'prefix = ~/.node' >> ~/.npmrc ## use ~/.node for global npm packages
```

```sh
$ npm install avalanche-cli -g ## no sudo required
```

```sh
$ avalanche-cli -h ## show help info
```

While the recommendation above holds true for GNU/Linux users, it probably may be skipped for macOS users. Further, `zsh` users may also need to adjust the instructions accordingly (since they are for `bash` users).

## Copyright

(c) 2021, Hasan Karahan, MSc in CS, ETH Zurich. Twitter: [@notexeditor](https://twitter.com/notexeditor).

[AVAX]: https://docs.avax.network/v1.0/en/quickstart/ava-getting-started/
[`jq`]: https://stedolan.github.io/jq/
[`npm`]: https://github.com/npm/cli
[`npx`]: https://github.com/npm/npx
