DOTFILE_DIR=$(cd $(dirname ${BASH_SOURCE}); pwd)

source ${DOTFILE_DIR}/.git-completion.bash
source ${DOTFILE_DIR}/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
PS1='\[\e[1;32m\]\u@\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\]$(__git_ps1 "(\[\e[1;31m\]%s\[\e[m\])")\$ '

source ${DOTFILE_DIR}/.functions.bash

. ${DOTFILE_DIR}/.z/z.sh
