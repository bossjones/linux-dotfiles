_jungle_completion() {
    COMPREPLY=( $( env COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   _JUNGLE_COMPLETE=complete $1 ) )
    return 0
}

complete -F _jungle_completion -o default jungle;
