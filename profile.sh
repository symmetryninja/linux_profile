#/usr/bin/env bash

LINUX_PROFILE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${LINUX_PROFILE_DIR}/aliases.sh
source ${LINUX_PROFILE_DIR}/hacks.sh
source ${LINUX_PROFILE_DIR}/ps1.sh
source ${LINUX_PROFILE_DIR}/git-completion.sh

## pyenv configs
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if [ -z ${1} ] ; then
  export ROSDIST="humble"
else
  export ROSDIST=${1}
fi
