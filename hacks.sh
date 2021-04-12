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

### Ros hacks
switch-project() {
    if [ -z ${1} ]
    then # no project
        PROJECTDIR=`cat ~/.last_ros_project`
        echo "No ROS project specified going with last: ${PROJECTDIR}";
    else 
        PROJECTDIR=$1
    fi
    
    echo ${PROJECTDIR} > ~/.last_ros_project
    export WORKSPACE=${PROJECTDIR}
    source /opt/ros/melodic/setup.bash
    source ${WORKSPACE}/devel/setup.bash
}