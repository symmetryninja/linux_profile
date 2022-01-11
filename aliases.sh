# Note - the `sn` prefix is just to prefix snips
## ssh with keepalive
alias ssh='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=15'

# Port stuff
alias sn_openports='sudo lsof -PiTCP -sTCP:LISTEN'

# Docker bits
alias sn_dockerRMC='docker rm $(docker ps -a -q)' # Delete all containers
alias sn_dockerRMI='docker rmi -f $(docker images -q)' # Delete all images
alias sn_dockerRMV='docker volume rm $(docker volume ls -q)' # Delete all volumes
alias sn_dockerRMALL='docker rm $(docker ps -a -q); docker rmi -f $(docker images -q); docker volume rm $(docker volume ls -q)' # Delete all

# Aliases for lazyness
alias sn_randomnumber="openssl rand -hex 16 | sed 's/\(....\)/\1:/g; s/.$//'"

# Some things commonly used in ROS projects
alias eb='nano ~/.bashrc'
alias sb='source ~/.bashrc'
alias gs='git status'
alias gp='git pull'
alias cw='cd ${WORKSPACE}'
alias cs='cd ${WORKSPACE}/src'
alias cm='cd ${WORKSPACE} && rm -rf devel build && catkin_make'
