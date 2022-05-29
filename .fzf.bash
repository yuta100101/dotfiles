# Setup fzf
# ---------
if [[ ! "$PATH" == */home/yuta100101/dotfiles/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/yuta100101/dotfiles/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/yuta100101/dotfiles/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/yuta100101/dotfiles/.fzf/shell/key-bindings.bash"
