#!/bin/bash

set -euxo pipefail

shell=$1

DOTFILE_DIR="$(cd $(dirname ${BASH_SOURCE}); pwd)"

pushd "${DOTFILE_DIR}"
git submodule update --init
popd

BACKUP_DIR=~/backup
mkdir -p "${BACKUP_DIR}"

_link () {
    if [[ -f ~/"${1}" ]]; then
        if [[ -L ~/"${1}" ]]; then
            if [[ "$(readlink ~/${1})" == "${DOTFILE_DIR}/${1}" ]]; then
                return
            else
                unlink "~/${1}"
            fi
        else
            mv "~/${1}" "${BACKUP_DIR}"
        fi
    fi
    ln -s "${DOTFILE_DIR}/${1}" ~
}

dotfiles=(".gitconfig" ".vimrc")

for dotfile in "${dotfiles[@]}"; do
    _link "${dotfile}"
done

if [[ "$(which fzf | wc -l)" -eq 0 ]]; then
    ${DOTFILE_DIR}/.fzf/install --key-bindings --completion --update-rc
fi

case "${shell}" in
    bash)
        if [[ (! -f ~/.bashrc) || (-z "$(grep "source ${DOTFILE_DIR}/.bashrc" ~/.bashrc)") ]]; then
            echo "source ${DOTFILE_DIR}/.bashrc" >> ~/.bashrc
        fi

        _link ".bash_aliases"
        if [[ -z "$(grep ". ~/.bash_aliases" ~/.bashrc)" ]]; then
            cat << EOF >> ~/.bashrc
        if [[ -f ~/.bash_aliases ]]; then
            . ~/.bash_aliases
        fi
EOF
        fi
        ;;
    fish)
        sudo apt install fish -y
        chsh -s /usr/bin/fish
        curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
        exec fish
        fisher install jethrokuan/z
        fisher install 0rax/fish-bd
        fisher install jethrokuan/fzf
        ;;
    *)
        echo "Unknown shell: ${shell}"
        exit 1
        ;;
esac

if [[ "$(which diff-highlight | wc -l)" -gt 0 ]]; then
    git config -f ~/.gitconfig.pager pager.log "diff-highlight | less"
    git config -f ~/.gitconfig.pager pager.show "diff-highlight | less"
    git config -f ~/.gitconfig.pager pager.diff "diff-highlight | less"
fi