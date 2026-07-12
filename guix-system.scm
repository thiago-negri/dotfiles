(use-modules (gnu))

(use-service-modules 
  desktop ; desktop-services
  ssh     ; openssh
  xorg    ; screenlocker
  )

(use-package-modules 
  fonts       ; font-iosevka
  gnuzilla    ; icecat, icedove
  image       ; flameshot
  linux       ; wireless-regdb
  pulseaudio  ; pulseaudio, pavucontrol
  suckless    ; dmenu
  terminals   ; wezterm, fzf
  vim         ; neovim
  wm          ; herbstluftwm
  xdisorg     ; xkb-switch, xftwidth, dzen, xwallpaper, xss-lock
  xfce        ; thunar
  xorg        ; setxkbmap, xrandr, xsetroot, xset
  )

;; Import nonfree linux module.
(use-modules (nongnu packages linux)
             (nongnu system linux-initrd))

(operating-system
  ;; Use nonfree Linux, offenders:
  ;; - WiFi, Audio, Bluetooth
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware
                  ; required for my audio card
                  sof-firmware))

  (locale "en_US.utf8")
  (timezone "America/Sao_Paulo")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "evohunz-guix")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "tnegri")
                  (group "users")
                  (home-directory "/home/tnegri")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  (packages (append (list
                      ; Required for my WiFi card
                      wireless-regdb
                      ; my desktop environment
                      herbstluftwm
                      wezterm
                      fzf
                      neovim
                      dmenu
                      xkb-switch
                      xftwidth
                      dzen
                      xwallpaper
                      xss-lock
                      pulseaudio
                      pavucontrol
                      flameshot
                      setxkbmap
                      xrandr
                      xsetroot
                      xset
                      icecat
                      icedove
                      thunar
                      font-iosevka
                      )
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services (append
    ;; Authorize nonguix substitutes.
    (modify-services %desktop-services
      (guix-service-type config => (guix-configuration
         (inherit config)
         (substitute-urls 
           (append (list "https://substitutes.nonguix.org") 
                   %default-substitute-urls))
         (authorized-keys 
           (append (list (local-file "./nonguix-signing-key.pub"))
                   %default-authorized-guix-keys)))))
    ;; My services.
    (list
      (service openssh-service-type)
      (service screen-locker-service-type 
               (screen-locker-configuration
                 (name "slock")
                 (program (file-append slock "/bin/slock"))))
      (set-xorg-configuration
       (xorg-configuration (keyboard-layout keyboard-layout))))))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

  (initrd-modules (append '("vmd") %base-initrd-modules))

  (swap-devices (list (swap-space
                        (target (uuid
                                 "cecf6c6a-fdf9-491c-b4d2-63ff1f0f27df")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/data")
                         (device (uuid
                                  "bb91a52d-f918-44a8-ac7f-8aafec365959"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "26E9-593A"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "042a841c-a074-4304-892a-c13b6f11eff3"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/home")
                         (device (uuid
                                  "4de6a24d-7635-4afd-83f4-0d935eef5cb4"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
