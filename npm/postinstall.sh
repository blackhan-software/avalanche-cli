#!/usr/bin/env bash
# shellcheck disable=SC2015
###############################################################################
NPM_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
###############################################################################

# if [ -n "$(command -v pkg-config)" ] ; then
#     TARGET="$(pkg-config --variable=completionsdir bash-completion)" ;
#     SOURCE="$NPM_SCRIPT/../avalanche-cli-completion.bash" ;
#     if [ -d "$TARGET" ] ; then
#         cp "$SOURCE" "$TARGET/avalanche-cli" 2>/dev/null || true ;
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

SRC_PATH=$(cd "$NPM_SCRIPT/.." >/dev/null 2>&1 && pwd) ;
SRC_FILE="$SRC_PATH/avalanche-cli-completion.bash" ;
echo "source \"$SRC_FILE\"" >> "$TGT_FILE" 2>/dev/null || true ;

###############################################################################
# zsh-completion

TGT_PATH="/usr/local/share/zsh/site-functions" ;
TGT_FILE="$TGT_PATH/_avalanche-cli" ;

if [ -d "$TGT_PATH" ] ; then
    ln -sf "$SRC_FILE" "$TGT_FILE" ;
fi

###############################################################################
###############################################################################
