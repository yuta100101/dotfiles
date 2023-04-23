if status is-interactive
    set -g theme_date_format "+%Y-%m-%d %H:%M:%S" # 日付のフォーマットを変更(例： 2022-03-01 23:22:22)
    set -g fish_prompt_pwd_dir_length 0           # フォルダ名が省略されていたものを省略しなくする
    # Commands to run in interactive sessions can go here
end

set PATH $HOME/dotfiles/.fzf/bin $PATH