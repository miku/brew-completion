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
    opts=`brew commands|sed -E -e 's/(Built-in|External) commands//g'|grep -v '^$'`

    case "${prev}" in
        search|update|home|edit|versions|bottle|cat)
            _brew_formula "$cur"
            return 0
            ;;
        uninstall|reinstall|test|upgrade|link|unlink)
            _brew_formula_installed "$cur"
            return 0
            ;;
        install)
            if [[ "$cur" == -* ]]; then
                COMPREPLY=( $(compgen -W '
                    --debug --devel --build-from-source
                    --cc= --env=std --env=super --fresh --interactive
                    --verbose --only-dependencies --ignore-dependencies
                    --git' -- "$cur") )
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
        --debug|--devel|--build-from-source|--cc=|--env=std|--env=super|\
        --fresh|--interactive|--verbose|--only-dependencies|\
        --ignore-dependencies|--git)
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
