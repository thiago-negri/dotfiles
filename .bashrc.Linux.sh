alias l="ls --color -lhAF --group-directories-first"

gg-find() {
    find "$HOME" \
        -maxdepth 3 \
        -mindepth 0 \
        -type d \
        -name .git \
        -exec dirname '{}' \; | \
        sort -u
}
