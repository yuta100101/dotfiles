#!/bin/bash

DOTFILE_DIR=$(cd $(dirname ${BASH_SOURCE}); pwd)

BACKUP_DIR=~/backup
mkdir -p ${BACKUP_DIR}

dotfiles=(".bash_aliases" ".gitconfig")

for dotfile in ${dotfiles[@]}; do
    if [ -f ~/${dotfile} ]; then
        if [ -L ~/${dotfile} ]; then
            if [ $(readlink ~/${dotfile}) == ${DOTFILE_DIR}/${dotfile} ]; then
                continue
            else
                unlink ~/${dotfile}
            fi
        else
            mv ~/${dotfile} ${BACKUP_DIR}
        fi
    fi
    ln -s ${DOTFILE_DIR}/${dotfile} ~
done

if ! grep -q "source ${DOTFILE_DIR}/.bashrc" ~/.bashrc; then
    echo "source ${DOTFILE_DIR}/.bashrc" >> ~/.bashrc
fi

if ! grep -q ". ~/.bash_aliases" ~/.bashrc; then
    cat << EOF >> ~/.bashrc
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF
fi

if [ $(which fzf | wc -l) -eq 0 ]; then
    ${DOTFILE_DIR}/.fzf/install
fi

if [ $(which diff-highlight | wc -l) -gt 0 ]; then
    git config --global pager.log "diff-highlight | less"
    git config --global pager.show "diff-highlight | less"
    git config --global pager.diff "diff-highlight | less"
fi