#/usr/bin/env bash
PROFILE_DIR=~/linux_profile
source ${PROFILE_DIR}/aliases.sh
source ${PROFILE_DIR}/hacks.sh
source ${PROFILE_DIR}/ps1.sh
source ${PROFILE_DIR}/git-completion.sh

## pyenv configs
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

if [ -z ${1} ] ; then
  export ROSDIST="melodic"
else
  export ROSDIST=${1}
fi
