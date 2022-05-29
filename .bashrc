###########
# DEFAULT #
###########

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

##########
# CUSTOM #
##########

source ~/dotfiles/.git-completion.bash
source ~/dotfiles/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
PS1='\[\e[1;32m\]\u@\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\]$(__git_ps1 "(\[\e[1;31m\]%s\[\e[m\])")\$ '

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fco - checkout git commit
fco() {
  local commit
  commit=$(git log --graph --color=always --remotes --branches \
               --format="%C(auto)%h%d %s %C(white)%C(bold)%cr" "$@" |
           fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort |
           grep -o '[a-f0-9]\{7\}') &&
	git checkout $commit

}

# fbr - checkout git branch (including remote branches)
fbr() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" |
             fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fshow - git commit browser
fshow() {
    git log --graph --color=always --remotes --branches\
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
		             xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
{}
FZF-EOF"
}

# fcd - cd to selected directory
fcd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
          -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}

# gsed - sed in git repository
gsed() {
    export existing=$1 && export new=$2
    _sed() {
        local file row
        file=$(echo $1 | cut -d ":" -f 1) &&
        row=$(echo $1 | cut -d ":" -f 2) &&
        sed -i -e "$row s/$existing/$new/" $file
    }
    export -f _sed &&
    git grep -n $existing |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort --multi --bind ctrl-a:select-all |
    grep -o '.*\..*:[0-9]*:' | xargs -I % bash -c "_sed %"  &&
    export -n existing new
}

. ~/dotfiles/.z/z.sh
