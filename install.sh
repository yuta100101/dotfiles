#!/bin/bash

DOTFILE_DIR=$(cd $(dirname $0) | pwd)

mkdir ~/.bachup

dotfiles=(".bashrc" ".bash_aliases" ".gitignore")

for dotfile in ${dotfiles[@]}; do
    if [ -f ~/$dotfile ]; then
        mv ~/$dotfile ~/.bachup
    fi
    ln -s $DOTFILE_DIR/$dotfile ~
done
