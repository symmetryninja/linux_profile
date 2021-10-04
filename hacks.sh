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

### Ros1 hacks
switch-project() {
    if [ -z ${1} ] ; then # no project
        PROJECTDIR=`cat ${PROFILE_DIR}/.tmp.last_ros_project`
        echo "No ROS project specified going with last: ${PROJECTDIR}";
    else 
        PROJECTDIR=$1
    fi

    echo ${PROJECTDIR} > ${PROFILE_DIR}/.tmp.last_ros_project
    export WORKSPACE=${PROJECTDIR}
    source /opt/ros/${ROSDIST}/setup.bash

    # ROSDIST custom defines (not implemented)
    ROS1LIST="bionic melodic"
    ROS2LIST="dashing eloquent foxy galactic"

    if [[ " $ROS1LIST " =~ .*\ $ROSDIST\ .* ]]; then
	source ${WORKSPACE}/devel/setup.bash
        return;
    fi
    if [[ " $ROS2LIST " =~ .*\ $ROSDIST\ .* ]]; then
	source ${WORKSPACE}/install/local_setup.bash
        echo "ROS 2 - ${ROSDIST}"
        return;
    fi

    echo "${ROS1LIST} RosDist not found"
}


