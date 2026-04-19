#!/bin/bash

stopwatch() {
    BEGIN=$(date +%s)
    BACK="\b\b\b\b\b"

    echo Starting Stopwatch...

    while true; do
        NOW=$(date +%s)
        let DIFF=$(($NOW - $BEGIN))
        let MINS=$(($DIFF / 60))
        let SECS=$(($DIFF % 60))

    #only echo count if its different than the last time
    if [ "$DIFF" != "$OLDDIFF" ]
    then
        #backspace 4 times to reset stopwatch position
        #The '-e' enables \b to be interpreted correctly
        #The '-n' avoids the newline character at the end
        echo -ne $BACK
        echo -ne `printf %02d $MINS`:`printf %02d $SECS`
    fi

    #define olddiff to current diff
    let OLDDIFF=DIFF
    sleep 0.5
    done
}


### some scrawled together script to see if a file is not referenced in another directory
#  useful for listing unused images in a doc tree

find_usage () {
 SOURCE_FOLDER=$1
 CONTENT_FOLDER=$2

 FILE_LIST=`ls ${SOURCE_FOLDER}`

 for FILE_ITEM in ${FILE_LIST};
 do 
  # echo "processing $f"; 
  MATCH=`grep -r ${FILE_ITEM} ${CONTENT_FOLDER} | wc -l`
  if [ ${MATCH} -lt 1 ]; 
   then echo "${FILE_ITEM} not used"; 
  fi
 done
}

# Cleans up unused snaps from snapd
# found this here: https://askubuntu.com/questions/1371833/howto-free-up-space-properly-on-my-var-lib-snapd-filesystem-when-snapd-is-unava
cleanup_snaps () {
  LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
  while read pkg revision; do
    sudo snap remove "$pkg" --revision="$revision"
  done
}

# gets your public IP
get-public-ip () {
  export PUBLIC_IP=`dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}'`
  echo "public IP: ${PUBLIC_IP} (exported as \$PUBLIC_IP)"
}


# checks if a path exists, checks if it's already in path and adds it to the PATH variable if required
profile_add_to_path() {
  [ -d "${1}" ] && [[ ! $PATH == *"${1}"* ]] && export PATH="${PATH}:${1}"
}

profile_setup_git() {
  if [ -n "${LINUX_PROFILE_DIR}/env.sh" ]; then
    source ${LINUX_PROFILE_DIR}/env.sh
    if [ ! -z "${ENV_PROFILE_GIT_EMAIL}" ]; then
      git config --global user.email ${ENV_PROFILE_GIT_EMAIL};
    else
      echo ENV_PROFILE_GIT_EMAIL not set
    fi
    if [ ! -z "${ENV_PROFILE_GIT_NAME}" ]; then
      git config --global user.name ${ENV_PROFILE_GIT_NAME}
    else 
      echo ENV_PROFILE_GIT_NAME not set
    fi
    if [ ! -z "${ENV_PROFILE_GIT_AUTO_REMOTE}" ]; then
      git config --global push.autoSetupRemote ${ENV_PROFILE_GIT_AUTO_REMOTE}
    else 
      echo ENV_PROFILE_GIT_AUTO_REMOTE not set
    fi
    if [ ! -z "${ENV_PROFILE_GIT_REBASE}" ]; then
      git config --global pull.rebase ${ENV_PROFILE_GIT_REBASE}
    else 
      echo ENV_PROFILE_GIT_REBASE not set
    fi
  else
    no profile env file
  fi
}