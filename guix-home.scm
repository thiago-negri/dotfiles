(use-modules
  (gnu home services desktop)
  (gnu home services shells)
  (gnu home services sound)
  (gnu home)
  (gnu packages)
  (gnu services)
  (guix gexp)
  )

(home-environment

  (packages (specifications->packages (list "vlc"
                                            "pinentry"
                                            "gnupg"
                                            "steam"
                                            "xkb-switch"
                                            "setxkbmap"
                                            "make"
                                            "xftwidth"
                                            "pavucontrol"
                                            "dmenu"
                                            "flameshot"
                                            "fzf"
                                            "neovim"
                                            "wezterm"
                                            "pkg-config"
                                            "gcc-toolchain"
                                            "unzip"
                                            "curl"
                                            "jq"
                                            "herbstluftwm"
                                            "emacs"
                                            "git"
                                            "icecat"
                                            "firefox")))

  (services
   (append (list (service home-bash-service-type
                          (home-bash-configuration
                            (guix-defaults? #f)
                            (bashrc
                              (list (local-file ".bashrc" "bashrc")))
                            (bash-profile
                              (list (local-file ".bash_profile" "bash_profile")))))
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type))
           %base-home-services)))
