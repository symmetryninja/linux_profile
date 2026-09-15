# Bash completion for termide.
#
# Install with either of:
#   eval "$(termide --completions bash)"          # in ~/.bashrc
#   termide --completions bash > /usr/share/bash-completion/completions/termide
#
# Option names are spelled out by hand; src/main.rs has a test that fails
# when a clap option is missing here.

# Ids of the detached sessions `termide --list-sessions` reports: the table's
# first column, minus its header. Prints nothing when there are none.
_termide_sessions() {
  termide --list-sessions 2>/dev/null | awk 'NR > 1 { print $1 }'
}

_termide() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  case "$prev" in
    --log-level)
      COMPREPLY=($(compgen -W "trace debug info warn error" -- "$cur"))
      return ;;
    --completions|--install-completions)
      COMPREPLY=($(compgen -W "bash zsh fish" -- "$cur"))
      return ;;
    --config)
      COMPREPLY=($(compgen -f -- "$cur"))
      return ;;
    --attach)
      # `--attach` takes an optional id; with no session running the next
      # word can only be a file to open.
      COMPREPLY=($(compgen -W "$(_termide_sessions)" -- "$cur"))
      [[ ${#COMPREPLY[@]} -eq 0 ]] && COMPREPLY=($(compgen -f -- "$cur"))
      return ;;
  esac

  if [[ "$cur" == -* ]]; then
    COMPREPLY=($(compgen -W "--log-level --no-lsp --config --diagnostics \
      --detached --attach --list-sessions --completions --install-completions \
      --help --version" -- "$cur"))
  else
    COMPREPLY=($(compgen -f -- "$cur"))
  fi
}

complete -o filenames -F _termide termide


# Autocompletion for just  
_just() {
    local i cur prev opts cmds
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}
    do
        case "${i}" in
            "$1")
                cmd="just"
                ;;
            
            *)
                ;;
        esac
    done

    case "${cmd}" in
        just)
            opts=" -n -q -u -v -e -l -h -V -f -d -c -s  --check --yes --dry-run --highlight --no-dotenv --no-highlight --quiet --shell-command --clear-shell-args --unsorted --unstable --verbose --changelog --choose --dump --edit --evaluate --fmt --init --list --summary --variables --help --version --chooser --color --command-color --dump-format --list-heading --list-prefix --justfile --set --shell --shell-arg --working-directory --command --completions --show --dotenv-filename --dotenv-path  <ARGUMENTS>... "
                if [[ ${cur} == -* ]] ; then
                    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                    return 0
                elif [[ ${COMP_CWORD} -eq 1 ]]; then
                    local recipes=$(just --summary 2> /dev/null)

                    if echo "${cur}" | \grep -qF '/'; then
                        local path_prefix=$(echo "${cur}" | sed 's/[/][^/]*$/\//')
                        local recipes=$(just --summary 2> /dev/null -- "${path_prefix}")
                        local recipes=$(printf "${path_prefix}%s\t" $recipes)
                    fi

                    if [[ $? -eq 0 ]]; then
                        COMPREPLY=( $(compgen -W "${recipes}" -- "${cur}") )
                        return 0
                    fi
                fi
            case "${prev}" in
                
                --chooser)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "auto always never" -- "${cur}"))
                    return 0
                    ;;
                --command-color)
                    COMPREPLY=($(compgen -W "black blue cyan green purple red yellow" -- "${cur}"))
                    return 0
                    ;;
                --dump-format)
                    COMPREPLY=($(compgen -W "just json" -- "${cur}"))
                    return 0
                    ;;
                --list-heading)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --list-prefix)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --justfile)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                    -f)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --set)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --shell)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --shell-arg)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --working-directory)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                    -d)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --command)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                    -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --completions)
                    COMPREPLY=($(compgen -W "zsh bash fish powershell elvish" -- "${cur}"))
                    return 0
                    ;;
                --show)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                    -s)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --dotenv-filename)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --dotenv-path)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        
    esac
}

complete -F _just -o bashdefault -o default just
