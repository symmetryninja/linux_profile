#/usr/bin/env bash
source ~/profile/aliases.sh
source ~/profile/hacks.sh
source ~/profile/ps1.sh
source ~/profile/git-completion.sh

## pyenv configs
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
