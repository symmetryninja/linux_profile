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


# AWS profile stuff - allows you to specify the aws-profile you wish to use
aws-profile() {
        if [ -z ${1} ]
        then # Blankville
                echo "No profile specified - select from:";
                cat ~/.aws/config | grep profile  | cut -d " " -f2 | cut -d "]" -f1
        else
                if [ -z `cat ~/.aws/config | grep profile  | cut -d " " -f2 | cut -d "]" -f1 | grep ${1}` ]
                then # Not found?? list the ones we have
                        echo "Profile not found, select from:";
                        cat ~/.aws/config | grep profile  | cut -d " " -f2 | cut -d "]" -f1
                else # coolzies - found one, here the login just to be smug
                        export AWS_PROFILE=${1};
                        echo selected profile: ${1} - account sts id;
                        echo `aws sts get-caller-identity`;
                fi
        fi
}

# assumes a role in the CLI based on params account number, role, session name (optional)
aws-assume-role() {
  export ASSUME_ROLE_ACCOUNT=$1
  export ASSUME_ROLE_ROLE=$2
  export ASSUME_ROLE_SESSION="${3:-myCoolSession}"
  export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
    $(aws sts assume-role \
    --role-arn arn:aws:iam::${ASSUME_ROLE_ACCOUNT}:role/${ASSUME_ROLE_ROLE} \
    --role-session-name ${ASSUME_ROLE_SESSION} \
    --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
    --output text))
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

## Ros project hacks - takes an input as a folder path, sources ROS and project code
## Takes an input, stores it in the .tmp.last_ros_project file
## if there's no input it gets the last-used folder
rp-dircheck() {
  if [ -z ${1} ] ; then # no project specified
    PROJECTDIR=`cat ${LINUX_PROFILE_DIR}/.tmp.last_ros_project`
    echo "Using previous project dir: ${PROJECTDIR}";
  else 
    PROJECTDIR=$1
    echo "Selected ros project at: ${PROJECTDIR}"
  fi
  export ROS_PROJECT_DIR=${PROJECTDIR}

  echo ${ROS_PROJECT_DIR} > ${LINUX_PROFILE_DIR}/.tmp.last_ros_project
  export WORKSPACE=${ROS_PROJECT_DIR}
}

rp() {
  rp-dircheck ${1}

  rp-ros

  # ROSDIST custom defines (not implemented)
  ROS1LIST="bionic melodic noetic"
  ROS2LIST="dashing eloquent foxy galactic humble iron"

  # ROS1
  if [[ " $ROS1LIST " =~ .*\ $ROSDIST\ .* ]]; then
    PROJECT_SETUP=${WORKSPACE}/devel/setup.bash
  fi

  # ROS2
  if [[ " $ROS2LIST " =~ .*\ $ROSDIST\ .* ]]; then
    PROJECT_SETUP=${WORKSPACE}/install/local_setup.bash
  fi


  if [[ -f "${PROJECT_SETUP}" ]]; then
    # Project
    echo "source/install: ${PROJECT_SETUP}"
    source ${PROJECT_SETUP}


  else
    echo "project: - no ${PROJECT_SETUP} - need a build?"
  fi

  
  # post - project-specific-script
  POST_EXEC_SCRIPT=${ROS_PROJECT_DIR}/ros-project-env.sh
  if [[ -f "${POST_EXEC_SCRIPT}" ]]; then
    source ${POST_EXEC_SCRIPT}
  fi
}

rp-ros() {
  echo "source/install: ${ROSDIST}"
  source /opt/ros/${ROSDIST}/setup.bash

  # Colcon
  if [[ -f "/usr/share/colcon_cd/function/colcon_cd.sh" ]]; then
    source /usr/share/colcon_cd/function/colcon_cd.sh
  fi
}

## Same as above but uses the pwd as the folder
rp-pwd() {
  rp `pwd`
}

### CD to current rosproject

rp-cd() {
  if [ -z ${ROS_PROJECT_DIR} ] ; then
    rp-dircheck
  fi
  cd ${ROS_PROJECT_DIR}
}