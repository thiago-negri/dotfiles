unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*)    os=mac;;
    MINGW*)     os=win;;
    *)          os=linux;;
esac

# Load stuff for Windows
if [[ "$os" -eq "win" ]]; then
    export PATH=$PATH:/usr/bin
    export PATH=$PATH:~/.fzf/bin
    export PATH=$PATH:/c/Projetos/zig/zls/zig-out/bin # ZLS master
    export PATH=$PATH:/c/windows-binaries
    export PATH=$PATH:/c/windows-binaries/vim91 # VIM can't symlink because it loads DLL from same folder
    export PATH=$PATH:"/c/Program Files/Neovim/bin"
    export PATH=$PATH:"/c/Program Files/Git"
    export PATH=$PATH:"/c/Program Files/Git/bin"
    export PATH=$PATH:"/c/Program Files/Git/usr/bin"
    export PATH=$PATH:"/c/Program Files/WezTerm"
fi

# Load stuff for Mac
if [[ "$os" -eq "mac" ]]; then
    export set DEV_HOME=/usr/local
    export set M2_HOME=/usr/local/mvn
    export set PATH="$M2_HOME/bin:$PATH"
    export set ANT_HOME=/usr/local/ant
    export set PATH="$ANT_HOME/bin:$PATH"
    export set GROOVY_HOME=/usr/local/groovy
    export set PATH="$GROOVY_HOME/bin:$PATH"
    export set GRAILS_HOME=/usr/local/grails
    export set PATH="$GRAILS_HOME/bin:$PATH"
    export set PHANTOMJS_HOME=/usr/local/phantomjs
    export set PATH="$PHANTOMJS_HOME/bin:$PATH"
    export set PATH=$PATH:/usr/local/mysql/bin:/usr/local/groovy/bin:/usr/local/tomcat/bin:/usr/local/phantomjs/bin:/usr/local/ant/bin:/usr/local/mvn/bin:/usr/local/bin:/usr/bin
    export set PATH="/usr/local/opt/mysql-client/bin:$PATH"
    export set PATH=$PATH:/usr/local/sbin
    export set PATH=$PATH:$HOME/.docker/bin
    export set JAVA_HOME=/Library/Java/JavaVirtualMachines/openlogic-openjdk-8.jdk/Contents/Home/
fi

# Set prompt
export PS1="%/ > "

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Make sure wezterm knows what the cwd is
wezterm set-working-directory

# Aliases
alias l="ls --color -lha"

# Functions
# NVM is too slow to load at startup
nvm_load() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

