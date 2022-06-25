#!/bin/bash

DOTFILE_DIR=$(cd $(dirname $0) | pwd)

mkdir -p ~/backup

dotfiles=(".bash_aliases" ".gitconfig")

for dotfile in ${dotfiles[@]}; do
    if [ -f ~/$dotfile ]; then
        mv ~/$dotfile ~/.bachup
    fi
    ln -s $DOTFILE_DIR/$dotfile ~
done

if [ ! grep -q "source $DOTFILE_DIR/.bashrc" ];then
    echo "source $DOTFILE_DIR/.bashrc" >> ~/.bashrc
fi

if [ $(which diff-highlight | wc -l) -gt 0 ]; then
    git config --global pager.log "diff-highlight | less"
    git config --global pager.show "diff-highlight | less"
    git config --global pager.diff "diff-highlight | less"
fi