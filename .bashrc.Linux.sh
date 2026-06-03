alias l="ls --color -lhAF --group-directories-first"

gg-find() {
    local folders=(
        "$HOME"
        "$HOME/babycenter/git"
    )
    local ignores=(
        "$HOME/.fzf/*"
    )
    find "${folders[@]}" \
        -maxdepth 3 \
        -mindepth 0 \
        -not -path "${ignores[@]}" \
        -type d \
        -name .git \
        -exec dirname '{}' \; | \
        sort -u
}
