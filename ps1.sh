# shellcheck disable=SC2034  # spare colours kept for tweaking the prompt
# a cool PS1 that is a colourised version of:
## username@host /current/folder/path AWS-profile-name  git-branchname
## $ >

# use git's own prompt helper (handles detached HEAD, rebase/merge states)
if [ -r /usr/lib/git-core/git-sh-prompt ]; then
        source /usr/lib/git-core/git-sh-prompt
fi
: "${GIT_PS1_SHOWDIRTYSTATE:=1}"        # * unstaged, + staged
#GIT_PS1_SHOWUNTRACKEDFILES=1          # % untracked (slow in big repos)
#GIT_PS1_SHOWUPSTREAM=auto             # <, >, <> vs upstream

function __git_branch_ps1() {
        declare -F __git_ps1 >/dev/null && __git_ps1 "%s "
}

function __aws_ps1() {
        [ -n "$AWS_PROFILE" ] && printf '%s ' "$AWS_PROFILE"
        [ -n "$ASSUME_ROLE_ACCOUNT" ] && printf '%s %s ' "$ASSUME_ROLE_ACCOUNT" "$ASSUME_ROLE_ROLE"
        return 0
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

PS1="${CYAN}\u${PS_CLEAR}@${GREEN}\h ${YELLOW}\w ${MAGENTA}\$(__aws_ps1)${GREEN}\$(__git_branch_ps1)\n${YELLOW}\$ ${PS_CLEAR}> "
