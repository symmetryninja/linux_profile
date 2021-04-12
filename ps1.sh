# cool PS1 
function __git_ps1() { 
        b=$(git branch 2>/dev/null | grep '^*' | colrm 1 2);
        [ ! -z "$b" ] && echo "${b} "; 
}

function __aws_ps1() {
        [ ! -z "$AWS_PROFILE" ] && echo "${AWS_PROFILE} "; 
}

# bash colors
BLUE='\[\033[34m\]'
CYAN='\[\033[36m\]'
GREEN='\[\033[32m\]'
YELLOW='\[\033[33;1m\]'
BLACK='\[\033[30m\]'
RED='\[\033[31m\]'
MAGENTA='\[\033[35m\]'
WHITE='\[\033[37m\]'
PS_CLEAR='\[\033[0m\]'

export PS1="${CYAN}\u${PS_CLEAR}@${GREEN}\h ${YELLOW}\w ${MAGENTA}\[\$(__aws_ps1)\]${GREEN}\[\$(__git_ps1)\]\n${YELLOW}\$ ${PS_CLEAR}> "