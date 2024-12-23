# CLI tool to pipe stdout to system's clipboard
unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*)    os=mac;;
    MINGW*)     os=win;;
    *)          os=linux;;
esac

# Load Windows PATH
if [[ "$os" -eq "win" ]]; then
    export PATH=$PATH:/usr/bin
    export PATH=$PATH:/c/Projetos/zig/zls/zig-out/bin # ZLS master
    export PATH=$PATH:/c/windows-binaries
    export PATH=$PATH:/c/windows-binaries/vim91 # VIM can't symlink because it loads DLL from same folder
    export PATH=$PATH:"/c/Program Files/Neovim/bin"
    export PATH=$PATH:"/c/Program Files/Git"
    export PATH=$PATH:"/c/Program Files/Git/bin"
    export PATH=$PATH:"/c/Program Files/Git/usr/bin"
    export PATH=$PATH:"/c/Program Files/WezTerm"
fi

# Set prompt
export PS1="%/ > "

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Make sure wezterm knows what the cwd is
wezterm set-working-directory

# Aliases
alias l="ls --color -lha"

