-- Reference: https://github.com/wez/wezterm/discussions/4796

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- local isWindows = wezterm.target_triple == "x86_64-pc-windows-msvc"
local isMac = wezterm.target_triple == "x86_64-apple-darwin"

-- Use gg's cache file to know all repositories in this machine
local gg_cache_filepath
if isMac then
    gg_cache_filepath = "/Users/thiago.negri/.gg/.cache"
else
    gg_cache_filepath = "/home/tnegri/.gg/.cache"
end

wezterm.on("update-right-status", function(window)
    window:set_right_status(window:active_workspace())
end)

M.toggle = function(window, pane)
    local repositories = {}

    local gg_cache_file = assert(io.open(gg_cache_filepath, "rb"))

    for repository in gg_cache_file:lines() do
        local basename = repository:gsub(".*[\\/]", "")
        table.insert(repositories, { label = tostring(basename), id = tostring(repository) })
    end

    gg_cache_file:close()

    window:perform_action(
        act.InputSelector({
            action = wezterm.action_callback(function(win, _, repository, basename)
                if basename and repository then
                    win:perform_action(act.SwitchToWorkspace({ name = basename, spawn = { cwd = repository } }), pane)
                end
            end),
            fuzzy = true,
            title = "Select project",
            choices = repositories,
        }),
        pane
    )
end

return M
