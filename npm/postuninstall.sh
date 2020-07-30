#!/usr/bin/env bash
# shellcheck disable=SC2015
###############################################################################

# if [ -n "$(command -v pkg-config)" ] ; then
#     FOLDER="$(pkg-config --variable=completionsdir bash-completion)" ;
#     SCRIPT="$FOLDER/avalanche-cli" ;
#     if [ -f "$SCRIPT" ] ; then
#         rm -f "$SCRIPT" 2>/dev/null || true ;
#     fi
# fi

###############################################################################
# bash-completion

TGT_FILE="$HOME/.bash_completion" ;
TMP_FILE="/tmp/.bash_completion-$RANDOM" ;

if [ -f "$TGT_FILE" ] ; then
    grep -v avalanche-cli < "$TGT_FILE" > "$TMP_FILE" 2>/dev/null || true ;
    [ -f "$TMP_FILE"  ] && mv "$TMP_FILE" "$TGT_FILE" 2>/dev/null || true ;
fi

###############################################################################
# zsh-completion

TGT_PATH="/usr/local/share/zsh/site-functions" ;
TGT_FILE="$TGT_PATH/_avalanche-cli" ;

if [ -f "$TGT_FILE" ] ; then
    rm -f "$TGT_FILE" 2>/dev/null || true ;
fi

###############################################################################
###############################################################################
