#!/bin/bash

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