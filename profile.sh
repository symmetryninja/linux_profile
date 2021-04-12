#/usr/bin/env bash
source ~/linux_profile/aliases.sh
source ~/linux_profile/hacks.sh
source ~/linux_profile/ps1.sh
source ~/linux_profile/git-completion.sh

## pyenv configs
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
