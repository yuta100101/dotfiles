# Setup fzf
# ---------
if [[ ! "$PATH" == *$DOTFILE_DIR/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$DOTFILE_DIR/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$DOTFILE_DIR/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source $DOTFILE_DIR/.fzf/shell/key-bindings.bash
