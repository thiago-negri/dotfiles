jvm_8() {
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/openlogic-openjdk-8.jdk/Contents/Home/
}

jvm_21() {
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home
}

# keep in sync with wezterm's sessionizer
gg-find() {
    local folders=(
        "$HOME/projects/bc"
        "$HOME/projects/ehg"
        "$HOME/projects/tnegri"
        "$HOME/projects/other"
        "$HOME/.config"
        "$HOME/.vim/pack/downloads/opt"
        "$HOME/.vim/pack/downloads/start"
    )
    find "${folders[@]}" -maxdepth 2 -mindepth 0 -type d -name .git -exec dirname '{}' \; | sort -u
}
