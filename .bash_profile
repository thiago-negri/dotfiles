[ -f "$HOME/.bash_profile.local.sh" ] && . "$HOME/.bash_profile.local.sh"

export TMP="$HOME/.tmp"
export TEMP="$HOME/.tmp"
export EDITOR=nvim
export PS1='\n\e[90m\u@\h:\w\e[0m\n\$ '
export BAT_THEME="Nord"

[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
