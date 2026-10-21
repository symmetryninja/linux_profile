#!/bin/bash

stopwatch() {
    local BEGIN NOW DIFF MINS SECS OLDDIFF
    local BACK="\b\b\b\b\b"
    BEGIN=$(date +%s)

    echo Starting Stopwatch...

    while true; do
        NOW=$(date +%s)
        DIFF=$((NOW - BEGIN))
        MINS=$((DIFF / 60))
        SECS=$((DIFF % 60))

    #only echo count if its different than the last time
    if [ "$DIFF" != "$OLDDIFF" ]
    then
        #backspace 4 times to reset stopwatch position
        #The '-e' enables \b to be interpreted correctly
        #The '-n' avoids the newline character at the end
        echo -ne "$BACK"
        printf '%02d:%02d' "$MINS" "$SECS"
    fi

    #define olddiff to current diff
    OLDDIFF=$DIFF
    sleep 0.5
    done
}


### some scrawled together script to see if a file is not referenced in another directory
#  useful for listing unused images in a doc tree

find_usage () {
 local SOURCE_FOLDER="$1"
 local CONTENT_FOLDER="$2"
 local FILE_PATH FILE_ITEM

 for FILE_PATH in "${SOURCE_FOLDER}"/*;
 do 
  FILE_ITEM=$(basename -- "${FILE_PATH}")
  # echo "processing $FILE_ITEM"; 
  if ! grep -rqF -- "${FILE_ITEM}" "${CONTENT_FOLDER}";
   then echo "${FILE_ITEM} not used"; 
  fi
 done
}

# Cleans up unused snaps from snapd
# found this here: https://askubuntu.com/questions/1371833/howto-free-up-space-properly-on-my-var-lib-snapd-filesystem-when-snapd-is-unava
cleanup_snaps () {
  LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
  while read -r pkg revision; do
    sudo snap remove "$pkg" --revision="$revision"
  done
}

# gets your public IP
get-public-ip () {
  PUBLIC_IP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')
  export PUBLIC_IP
  echo "public IP: ${PUBLIC_IP} (exported as \$PUBLIC_IP)"
}


# checks if a path exists, checks if it's already in path and adds it to the PATH variable if required
profile_add_to_path() {
  [ -d "${1}" ] && [[ ":${PATH}:" != *":${1}:"* ]] && export PATH="${PATH}:${1}"
}

profile_setup_git() {
  if [ -f "${LINUX_PROFILE_DIR}/env.sh" ]; then
    source "${LINUX_PROFILE_DIR}/env.sh"
    if [ -n "${ENV_PROFILE_GIT_EMAIL}" ]; then
      git config --global user.email "${ENV_PROFILE_GIT_EMAIL}"
    else
      echo ENV_PROFILE_GIT_EMAIL not set
    fi
    if [ -n "${ENV_PROFILE_GIT_NAME}" ]; then
      git config --global user.name "${ENV_PROFILE_GIT_NAME}"
    else 
      echo ENV_PROFILE_GIT_NAME not set
    fi
    if [ -n "${ENV_PROFILE_GIT_AUTO_REMOTE}" ]; then
      git config --global push.autoSetupRemote "${ENV_PROFILE_GIT_AUTO_REMOTE}"
    else 
      echo ENV_PROFILE_GIT_AUTO_REMOTE not set
    fi
    if [ -n "${ENV_PROFILE_GIT_REBASE}" ]; then
      git config --global pull.rebase "${ENV_PROFILE_GIT_REBASE}"
    else 
      echo ENV_PROFILE_GIT_REBASE not set
    fi
  else
    echo "no profile env file: ${LINUX_PROFILE_DIR}/env.sh (see example.env.sh)"
  fi
}
