# Bash completion for Homebrew package manager, 
# http://mxcl.github.com/homebrew/
_brew_formula()
{
    local formulae
    
    formulae=`brew search`
    COMPREPLY=( $(compgen -W '$formulae' -- "$1") )
}

_brew_formula_installed()
{
    local formulae

    formulae=`brew list`
    COMPREPLY=( $(compgen -W '$formulae' -- "$1") )
}

_brew()
{
    local cur prev cmd i
    COMPREPLY=()
    
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="audit cat cleanup create deps doctor edit fetch home info install \
    link list ln log man missing options outdated prune remove search server \
    test uninstall unlink update uses versions which"

    case "${prev}" in
        search|update|home|edit)
            _brew_formula "$cur"
            return 0
            ;;
        uninstall)
            _brew_formula_installed "$cur"
            return 0
            ;;
        install)
            if [[ "$cur" == -* ]]; then
                COMPREPLY=( $(compgen -W '--HEAD --debug --interactive
                    --verbose --ignore-dependencies' -- "$cur") )
            else
                _brew_formula "$cur"
            fi
            return 0
            ;;
        create)
            if [[ "$cur" == -* ]]; then
                COMPREPLY=( $(compgen -W '--macports' -- "$cur") )
            fi
            return 0
            ;;
        info)
            if [[ "$cur" == -* ]]; then
                COMPREPLY=( $(compgen -W '--github' -- "$cur") )
            else
                _brew_formula "$cur"
            fi
            return 0
            ;;
        list)
            if [[ "$cur" == -* ]]; then
                COMPREPLY=( $(compgen -W '--unbrewed' -- "$cur") )
            else
                _brew_formula_installed "$cur"
            fi
            return 0
            ;;
    esac
    
    case "${prev}" in
        # post-install, post-info
        --debug|--interactive|--verbose|--ignore-dependencies|--github)
            _brew_formula "$cur"
            return 0
            ;;
        --unbrewed)
            _brew_formula_installed "$cur"
            return 0
            ;;
    esac

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi

}
complete -F _brew brew
