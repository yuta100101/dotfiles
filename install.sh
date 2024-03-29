#!/bin/bash

set -euxo pipefail

DOTFILE_DIR="$(cd $(dirname ${BASH_SOURCE}); pwd)"

pushd "${DOTFILE_DIR}"
git submodule update --init
popd

BACKUP_DIR=~/backup
mkdir -p "${BACKUP_DIR}"

dotfiles=(".bash_aliases" ".gitconfig" ".vimrc")

for dotfile in "${dotfiles[@]}"; do
    if [[ -f ~/"${dotfile}" ]]; then
        if [[ -L ~/"${dotfile}" ]]; then
            if [[ "$(readlink ~/${dotfile})" == "${DOTFILE_DIR}/${dotfile}" ]]; then
                continue
            else
                unlink "~/${dotfile}"
            fi
        else
            mv "~/${dotfile}" "${BACKUP_DIR}"
        fi
    fi
    ln -s "${DOTFILE_DIR}/${dotfile}" ~
done

if [[ (! -f ~/.bashrc) || (-z "$(grep "source ${DOTFILE_DIR}/.bashrc" ~/.bashrc)") ]]; then
    echo "source ${DOTFILE_DIR}/.bashrc" >> ~/.bashrc
fi

if [[ -z "$(grep ". ~/.bash_aliases" ~/.bashrc)" ]]; then
    cat << EOF >> ~/.bashrc
if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi
EOF
fi

if [[ "$(which fzf | wc -l)" -eq 0 ]]; then
    ${DOTFILE_DIR}/.fzf/install --key-bindings --completion --update-rc
fi

if [[ "$(which diff-highlight | wc -l)" -gt 0 ]]; then
    git config -f ~/.gitconfig.pager pager.log "diff-highlight | less"
    git config -f ~/.gitconfig.pager pager.show "diff-highlight | less"
    git config -f ~/.gitconfig.pager pager.diff "diff-highlight | less"
fi