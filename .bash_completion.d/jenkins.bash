# jenkins(1) completion                                        -*- shell-script -*-

_jenkins()
{
    local cur prev words cword
    _init_completion || return

    opts="jobs \
        queue \
        building \
        builds \
        start \
        info \
        configxml \
        setbranch \
        stop \
        console \
        changes \
        -h \
        --help \
        --host \
        --username \
        --password \
        --version"

    case $prev in
      jobs)
        opts="-h --help -a -p"
          ;;
      builds|start|info|configxml|setbranch|stop|console|changes)
        opts="-h --help"

        # if the cached-jobs file exists suggest also job names
        CACHE_DIR=${XDG_CACHE_HOME:-~/.cache}"/python-jenkins-cli"
        if [ -r $CACHE_DIR/job_cache ]; then
          opts="$opts $(cat $CACHE_DIR/job_cache)"
        fi
          ;;
      queue|building)
        opts="-h --help"
          ;;
    esac

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    return 0
}

complete -F _jenkins jenkins

# ex: ts=4 sw=4 et filetype=sh

