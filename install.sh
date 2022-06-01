#!/bin/bash

DOTFILE_DIR=$(cd $(dirname $0) | pwd)

mkdir ~/backup

dotfiles=(".bashrc" ".bash_aliases" ".gitconfig")

for dotfile in ${dotfiles[@]}; do
    if [ -f ~/$dotfile ]; then
        mv ~/$dotfile ~/.bachup
    fi
    ln -s $DOTFILE_DIR/$dotfile ~
done
