# keep in sync with wezterm's sessionizer
gg-find() {
    local folders=(
        "$HOME/.gg"
        "$HOME/projects"
        "$HOME/.config"
        "$HOME/scripts"
    )
    find "${folders[@]}" -maxdepth 2 -mindepth 1 -type d -name .git -exec dirname '{}' \; | sort -u
}
