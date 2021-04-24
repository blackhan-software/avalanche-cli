#compdef avalanche-cli
# shellcheck disable=2207
###############################################################################

function _avalanche_cli {
    local curr_0="${COMP_WORDS[$(( COMP_CWORD - 0 ))]}" ;
    local curr_1="${COMP_WORDS[$(( COMP_CWORD - 1 ))]}" ;
    local curr_2="${COMP_WORDS[$(( COMP_CWORD - 2 ))]}" ;
    local word_1="${COMP_WORDS[1]}" ;
    local word_2="${COMP_WORDS[2]}" ;
    COMPREPLY=() ;
    local sup_cmds ; sup_cmds="$(avalanche-cli --list-commands)" ;
    local sub_cmds ;
    local sup_opts ; sup_opts="$(avalanche-cli --list-options)" ;
    local sub_opts ;
    if [[ -n ${word_1} ]] && [[ " ${sup_cmds[*]} " == *" ${word_1} "* ]] ; then
        sub_cmds="$(avalanche-cli "${word_1}" --list-commands)" ;
        if [[ -n ${word_2} ]] && [[ " ${sub_cmds[*]} " == *" ${word_2} "* ]] ; then
            sub_opts="$(avalanche-cli "${word_1}" "${word_2}" --list-options)" ;
            if [ "${curr_1}" == "=" ] ; then
                ## avalanche-cli command sub-command --option=+ [TAB]
                local sug_opts=( $(compgen -W "${sub_opts}" -- "${curr_2}=${curr_0}") ) ;
                for opt in "${sug_opts[@]}" ; do
                    if [[ "$opt" =~ ([^=]+)=([^=]+) ]] ; then
                        COMPREPLY+=( "${BASH_REMATCH[2]}" ) ;
                    fi
                done
            elif [ "${curr_0}" == "=" ] ; then
                ## avalanche-cli command sub-command --option=* [TAB]
                local sug_opts=( $(compgen -W "${sub_opts}" -- "${curr_1}=") ) ;
                for opt in "${sug_opts[@]}" ; do
                    if [[ "$opt" =~ ([^=]+)=([^=]+) ]] ; then
                        COMPREPLY+=( "${BASH_REMATCH[2]}" ) ;
                    fi
                done
            else
                ## avalanche-cli command sub-command * [TAB]
                COMPREPLY+=( $(compgen -W "${sub_opts}" -- "${curr_0}") ) ;
            fi
            return 0 ;
        fi
        ## avalanche-cli command [TAB]
        sub_opts="$(avalanche-cli "${word_1}" --list-options)" ;
        COMPREPLY+=( $(compgen -W "${sub_opts}" -- "${curr_0}") ) ;
        sub_cmds="$(avalanche-cli "${word_1}" --list-commands)" ;
        COMPREPLY+=( $(compgen -W "${sub_cmds}" -- "${curr_0}") ) ;
        return 0 ;
    fi
    ## avalanche-cli [TAB]
    COMPREPLY+=( $(compgen -W "${sup_opts}" -- "${curr_0}") ) ;
    COMPREPLY+=( $(compgen -W "${sup_cmds}" -- "${curr_0}") ) ;
    return 0 ;
}

###############################################################################

if [ -n "$ZSH_VERSION" ] ; then
    autoload bashcompinit ;
    bashcompinit ;
fi

complete -F _avalanche_cli avalanche-cli ;

###############################################################################
###############################################################################
