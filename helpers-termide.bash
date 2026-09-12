# Termide autocomplete
_termide_completions() {
  local cur prev opts
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  if command -v termide &> /dev/null; then
    opts=$(termide --help 2>/dev/null | grep -oE -- '--[a-zA-Z-]+' | sort -u | tr '\n' ' ')
  fi

  case "${prev}" in
    --log-level)
      COMPREPLY=($(compgen -W "trace debug info warn error" -- "${cur}"))
      return
      ;;
    --config)
      COMPREPLY=($(compgen -f -- "${cur}"))
      return
      ;;
    --attach)
      if command -v termide &> /dev/null; then
        local sessions
        sessions=$(termide --list-sessions 2>/dev/null | tail -n +2 | awk '{print $1}')
        COMPREPLY=($(compgen -W "${sessions}" -- "${cur}"))
      fi
      return
      ;;
  esac

  if [[ "${cur}" == -* ]]; then
    COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
  else
    COMPREPLY=($(compgen -f -- "${cur}"))
  fi
}

complete -F _termide_completions termide
