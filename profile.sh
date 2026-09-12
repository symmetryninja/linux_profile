#!/usr/bin/env bash
LINUX_PROFILE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -f "${LINUX_PROFILE_DIR}/env.sh" ]; then
  source ${LINUX_PROFILE_DIR}/env.sh
fi

source ${LINUX_PROFILE_DIR}/aliases.sh
source ${LINUX_PROFILE_DIR}/helpers-aws.sh
source ${LINUX_PROFILE_DIR}/helpers-termide.sh
source ${LINUX_PROFILE_DIR}/helpers-ros.sh
source ${LINUX_PROFILE_DIR}/helpers-misc.sh
source ${LINUX_PROFILE_DIR}/ps1.sh
source ${LINUX_PROFILE_DIR}/git-completion.bash

## pyenv configs
if [ -z "${DISABLE_PYENV}" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  profile_add_to_path "$PYENV_ROOT/bin"
  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi
fi

# Ros dist set default
if [ -z "$ROSDIST" ]; then
  if [ -z ${1} ] ; then
    export ROSDIST="humble"
  else
    export ROSDIST=${1}
  fi
fi
