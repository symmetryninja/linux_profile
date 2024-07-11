# ROS Hacks

## Aliases

I have built a few aliases for things I use a lot.

CD to workspace `cw`

```bash
alias cw='cd ${WORKSPACE}'
```

CD to workspace src `cws`

```bash
alias cs='cd ${WORKSPACE}/src'
```

Colcon build `cb`

```bash
alias cb='cd ${WORKSPACE} && colcon build'
```

Colcon build symlink `cbs`

```bash
alias cbs='cd ${WORKSPACE} && colcon build --symlink-install'
```

## ROS profile functions

Functions to make working in multiple ROS projects a bit easier. The functions use a file to determine the last ros project.

### `rp()`

Sets the rosproject variable to the specified folder and then loads the ROS distro `setup.bash` and the ROS project `setup.bash`

Usage:

- `rp $path-to-ros-workspace` - set the variable and load the ROS bash and project bash
- `rp` - load the ROS bash and project bash

**important:** the folder needs to be the workspace, i.e. 1 folder above the `src` folder.

### `rp-pwd()`

calls `rp` and autospecifies the current directory.

Usage:

- `rp-pwd`

### `rp-ros()`

loads the ROS distro `setup.bash`

- `rp-ros`

### `rp-cd()`

Jumps to the previous ROS workspace folder.

## ROS auto-profile-injection

In the `rp()` feature, the script looks for a file in the workspace dir called `ros-project-env.sh`.

This is for injecting variables that are env specific. 

**Example:** For a project that runs on a robot with a remove dev environment for things like RVIZ and you're using a ros_discovery_server and want to specify a different location for your laptop and the robot.

On the laptop I have an environment variable `export INSTANCE_ROLE=laptop` and I have 3 profile files.

### `ros-project-env.sh`

```bash
#! /usr/bin/env bash
# this script is executed after running rp (ros-project jacker function)
CURRENT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export ROBOT_NAMESPACE=
export ROS_DOMAIN_ID=0
export TURTLEBOT4_DIAGNOSTICS=0
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp

if [ -z "$INSTANCE_ROLE" ]; then
  echo "sourcing robot startup (startup_robot.sh)"
  source ${CURRENT_DIR}/startup_robot.sh
else
  echo "sourcing ${INSTANCE_ROLE} startup (startup_${INSTANCE_ROLE}.sh)"
  source ${CURRENT_DIR}/startup_${INSTANCE_ROLE}.sh
fi
```

### `startup_laptop.sh`

```bash
#!/usr/bin/env bash
## discovery server autoconfig
# get PWD
CURRENT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# discover server info
ROS_DISCOVERY_SERVER_IP=192.168.1.10
ROS_DISCOVERY_SERVER_PORT=11811

# using a template file
TEMPLATE="$CURRENT_DIR/customised_ros_config/fastdds_discovery_super_client_template.xml"
TEMPLATE_OUT="$CURRENT_DIR/customised_ros_config/fastdds_discovery_super_client.xml"

# rewrite template out to template DIR, replacing RASPBERRY_PI_IP with ROS_DISCOVERY_SERVER var
cat ${TEMPLATE} | \
sed -e "s/ROS_DISCOVERY_SERVER_IP/${ROS_DISCOVERY_SERVER_IP}/g; s/ROS_DISCOVERY_SERVER_PORT/${ROS_DISCOVERY_SERVER_PORT}/g; " \
> ${TEMPLATE_OUT}
export FASTRTPS_DEFAULT_PROFILES_FILE=${TEMPLATE_OUT}

# adds IP forwarding (used on a turtlebot4)
sudo ip route add 192.168.186.0/24 via ${ROS_DISCOVERY_SERVER_IP}
```

### `startup_robot.sh`

```bash
#!/usr/bin/env bash
CURRENT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# discover server info
ROS_DISCOVERY_SERVER_IP=192.168.1.10
ROS_DISCOVERY_SERVER_PORT=11811

# using a template file
TEMPLATE="$CURRENT_DIR/customised_ros_config/fastdds_discovery_super_client_template.xml"
TEMPLATE_OUT="$CURRENT_DIR/customised_ros_config/fastdds_discovery_super_client.xml"

# rewrite template out to template DIR, replacing RASPBERRY_PI_IP with ROS_DISCOVERY_SERVER var
cat ${TEMPLATE} | \
sed -e "s/ROS_DISCOVERY_SERVER_IP/${ROS_DISCOVERY_SERVER_IP}/g; s/ROS_DISCOVERY_SERVER_PORT/${ROS_DISCOVERY_SERVER_PORT}/g; " \
> ${TEMPLATE_OUT}
export FASTRTPS_DEFAULT_PROFILES_FILE=${TEMPLATE_OUT}

rp ${CURRENT_DIR}
ros2 launch projectname launchfilename
```

## WSL attempts at gpu native execution

Using this instruction [https://gazebosim.org/docs/fortress/install_ubuntu_src](https://gazebosim.org/docs/fortress/install_ubuntu_src)

I used the below yaml as collection-fortress.yaml [source here](https://github.com/gazebosim/gz-sim/issues/1116#issuecomment-1142388038)

```yaml
---
repositories:
  ign-cmake:
    type: git
    url: https://github.com/ignitionrobotics/ign-cmake
    version: ign-cmake2
  ign-common:
    type: git
    url: https://github.com/ignitionrobotics/ign-common
    version: ign-common4
  ign-fuel-tools:
    type: git
    url: https://github.com/ignitionrobotics/ign-fuel-tools
    version: ign-fuel-tools7
  ign-gazebo:
    type: git
    url: https://github.com/TheConstructAi/gz-sim
    version: ign-gazebo6
  ign-gui:
    type: git
    url: https://github.com/TheConstructAi/gz-gui
    version: ign-gui6
  ign-launch:
    type: git
    url: https://github.com/ignitionrobotics/ign-launch
    version: ign-launch5
  ign-math:
    type: git
    url: https://github.com/ignitionrobotics/ign-math
    version: ign-math6
  ign-msgs:
    type: git
    url: https://github.com/ignitionrobotics/ign-msgs
    version: ign-msgs8
  ign-physics:
    type: git
    url: https://github.com/ignitionrobotics/ign-physics
    version: ign-physics5
  ign-plugin:
    type: git
    url: https://github.com/ignitionrobotics/ign-plugin
    version: ign-plugin1
  ign-rendering:
    type: git
    url: https://github.com/TheConstructAi/gz-rendering
    version: ign-rendering6
  ign-sensors:
    type: git
    url: https://github.com/TheConstructAi/gz-sensors
    version: ign-sensors6
  ign-tools:
    type: git
    url: https://github.com/ignitionrobotics/ign-tools
    version: ign-tools1
  ign-transport:
    type: git
    url: https://github.com/ignitionrobotics/ign-transport
    version: ign-transport11
  ign-utils:
    type: git
    url: https://github.com/ignitionrobotics/ign-utils
    version: ign-utils1
  sdformat:
    type: git
    url: https://github.com/osrf/sdformat
    version: sdf12
```
