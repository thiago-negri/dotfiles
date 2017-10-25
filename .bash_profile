
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# Android SDK home
export ANDROID_HOME=/home/tnegri/android-sdk-linux

# Java home
export JAVA_HOME=/usr/lib/jvm/java-8-oracle

# 256 colors terminal
export TERM=xterm-256color

# Let Ctrl-S save files in VIM
stty -ixon

# Add Cargo binaries to PATH
export PATH="$HOME/.cargo/bin:$PATH"

eval `dircolors ~/.dir_colors/dircolors`

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
