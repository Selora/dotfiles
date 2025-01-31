if status is-interactive
    # Commands to run in interactive sessions can go here
end

### VIM MODE!
# https://fishshell.com/docs/current/cmds/fish_vi_key_bindings.html
# https://fishshell.com/docs/current/interactive.html#vi-mode
set -g fish_key_bindings fish_vi_key_bindings

alias vim nvim
alias vis sudoedit
alias ls eza
alias lxc incus
alias cat "bat -pP"
alias bless bat
#alias cd zoxide

# Per-system alias
touch ~/.alias.fish # If it doesn't exists
. ~/.alias.fish

set -gx LANG "en_US.utf-8"
set -gx EDITOR nvim

fish_add_path ~/.local/bin


# Setup zoxide
#source ~/.config/fish/zoxide.fish
zoxide init --cmd cd fish | source
direnv hook fish | source
starship init fish | source

fzf_configure_bindings
set fzf_preview_dir_cmd eza --all --color=always
set fzf_fd_opts --hidden --no-ignore --max-depth 5

#        COMMAND            |  DEFAULT KEY SEQUENCE         |  CORRESPONDING OPTION
#        Search Directory   |  Ctrl+Alt+F (F for file)      |  --directory
#        Search Git Log     |  Ctrl+Alt+L (L for log)       |  --git_log
#        Search Git Status  |  Ctrl+Alt+S (S for status)    |  --git_status
#        Search History     |  Ctrl+R     (R for reverse)   |  --history
#        Search Processes   |  Ctrl+Alt+P (P for process)   |  --processes
#        Search Variables   |  Ctrl+V     (V for variable)  |  --variables

set -gx SSH_AGENT_PID ""
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/selora/.lmstudio/bin
