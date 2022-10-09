#!/bin/bash

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

# fadd - git add files
fadd() {
    local selected
    selected=$(git status -s | fzf -m --preview="echo {} | awk '{print \$2}' | xargs git diff --color" | awk '{print $2}')
    if [[ -n "$selected" ]]; then
        selected=$(tr '\n' ' ' <<< "$selected")
        git add $selected
        echo "Completed: git add $selected"
    fi
}

# fcd - cd to selected directory
fcd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
          -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}

# gsed - replace in git repository
gsed() {
    local existing new
    existing=$1 && new=$2
    export -f _sed &&
    git grep -n --color=always $existing |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort --multi --bind ctrl-a:select-all |
    grep -o '.*\..*:[0-9]*:' | xargs -I % bash -c "_sed % $existing $new"
}

_sed() {
    local file row
    file=$(echo $1 | cut -d ":" -f 1) &&
    row=$(echo $1 | cut -d ":" -f 2) &&
    sed -i -e "$row s/$2/$3/" $file
}

# fact - conda activate
fact() {
    local env
    env=$(conda env list |
          fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort |
          cut -d " " -f 1) &&
    conda activate $env
}

touchp() {
    local filepath
    filepath=$1
    mkdir -p $(dirname ${filepath}) && touch ${filepath}
}

cdp() {
    local dirpath
    dirpath=$1
    mkdir -p ${dirpath} && cd ${dirpath}
}
