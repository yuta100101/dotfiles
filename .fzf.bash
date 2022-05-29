# Setup fzf
# ---------
if [[ ! "$PATH" == *~/dotfiles/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}~/dotfiles/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "~/dotfiles/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source ~/dotfiles/.fzf/shell/key-bindings.bash
