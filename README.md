# nixy modules

> 9 modules, 195 options

<details>
<summary>apple [nixos] (3 options)</summary>

| Option | Type | Default |
|--------|------|---------|
| `batteryChargeLimit` | null or signed integer | - |
| `peripheralFirmwareDirectory` | null or absolute path | - |
| `setupAsahiSound` | boolean | `true` |

</details>

<details>
<summary>base [nixos] (58 options)</summary>

| Option | Type | Default |
|--------|------|---------|
| `boot.enableContainers` | boolean | `false` |
| `boot.enableZswap` | boolean | `true` |
| `boot.extraModulePackages` | list of string | `[]` |
| `boot.initrd.availableKernelModules` | list of string | `[]` |
| `boot.initrd.kernelModules` | list of string | `[]` |
| `boot.kernelModules` | list of string | `[]` |
| `boot.kernelPackages` | string | `"linuxPackages_latest"` |
| `boot.kernelParams` | list of string | `[]` |
| `boot.loader.efi.canTouchEfiVariables` | boolean | `true` |
| `boot.loader.timeout` | signed integer | `1` |
| `boot.plymouth.enable` | boolean | `false` |
| `boot.sysctl` | attribute set | `{}` |
| `boot.tmp.tmpfsHugeMemoryPages` | string | `"advise"` |
| `boot.tmp.tmpfsSize` | null or string | - |
| `boot.tmp.useTmpfs` | boolean | `false` |
| `disks.boot.device` | string | `""` |
| `disks.boot.fsType` | string | `"vfat"` |
| `disks.boot.options` | list of string | `["fmask=0022","dmask=0022"]` |
| `disks.btrfs.device` | string | `"/dev/mapper/root"` |
| `disks.btrfs.options` | list of string | `["noatime","compress=zstd","space_cache=v2"]` |
| `disks.btrfs.subvolumes.nix` | boolean | `true` |
| `disks.btrfs.subvolumes.persist` | boolean | `true` |
| `disks.btrfs.subvolumes.swap` | boolean | `true` |
| `disks.btrfs.subvolumes.tmp` | boolean | `true` |
| `disks.enable` | boolean | `false` |
| `disks.luks.device` | string | `""` |
| `disks.luks.enable` | boolean | `false` |
| `disks.luks.name` | string | `"root"` |
| `disks.root.tmpfsSize` | string | `"2G"` |
| `disks.root.useTmpfs` | boolean | `true` |
| `disks.swap.enable` | boolean | `true` |
| `disks.swap.path` | string | `"/swap/swapfile"` |
| `dns` | list of string | `["1.1.1.1","2606:4700:4700::1111","8.8.8.8","2001:4860:4860::8888"]` |
| `hostName` | null or string | - |
| `keyMap` | string | `"us"` |
| `locale` | string | `"C.UTF-8"` |
| `network.wired.enable` | boolean | `true` |
| `network.wired.interface` | string | `"eth0"` |
| `network.wireless.enable` | boolean | `true` |
| `network.wireless.interface` | string | `"wlan0"` |
| `nix.experimentalFeatures` | list of string | `["nix-command","flakes","ca-derivations","auto-allocate-uids","cgroups","no-url-literals","pipe-operators"]` |
| `nix.gc.automatic` | boolean | `false` |
| `nix.gc.dates` | string | `"weekly"` |
| `nix.gc.options` | string | `"--delete-older-than 30d"` |
| `nix.substituters` | list of string | `[]` |
| `nix.trustedPublicKeys` | list of string | `[]` |
| `nix.trustedUsers` | list of string | `["@wheel"]` |
| `notDetected.enable` | boolean | `true` |
| `sessionVariables` | attribute set | `{}` |
| `stateVersion` | string | `"25.11"` |
| `systemPackages` | list of string | `[]` |
| `timeZone` | string | `"UTC"` |
| `tpm2.enable` | boolean | `false` |
| `users` | attribute set of (submodule) | `{}` |
| `wheelNeedsPassword` | boolean | `true` |
| `zram.algorithm` | string | `"zstd"` |
| `zram.enable` | boolean | `false` |
| `zram.size` | string | `"ram"` |

</details>

<details>
<summary>cli (26 options)</summary>

| Option | Type | Default |
|--------|------|---------|
| `fish.enable` | boolean | `false` |
| `fish.flakePath` | null or string | - |
| `git.defaultBranch` | string | `"main"` |
| `git.enable` | boolean | `false` |
| `git.extraConfig` | attribute set | `{}` |
| `git.lfs` | boolean | `true` |
| `git.merge.conflictStyle` | string | `"diff3"` |
| `git.merge.tool` | string | `"vimdiff"` |
| `git.pull.rebase` | boolean | `true` |
| `git.signing.enable` | boolean | `false` |
| `git.signing.format` | string | `"ssh"` |
| `git.signing.key` | string | `"~/.ssh/id_ed25519"` |
| `git.userEmail` | string | `""` |
| `git.userName` | string | `""` |
| `neovim.background` | string | `"soft"` |
| `neovim.colorscheme` | string | `"everforest"` |
| `neovim.defaultEditor` | boolean | `true` |
| `neovim.enable` | boolean | `false` |
| `neovim.extraConfig` | strings concatenated with "\n" | `""` |
| `neovim.extraPlugins` | list of string | `[]` |
| `neovim.lsp.enable` | boolean | `true` |
| `neovim.lsp.servers` | list of string | `["gopls","rust_analyzer","nil_ls","clangd","ruff"]` |
| `neovim.tabWidth` | signed integer | `2` |
| `neovim.transparent` | boolean | `true` |
| `neovim.viAlias` | boolean | `true` |
| `neovim.vimAlias` | boolean | `true` |

</details>

<details>
<summary>desktop (18 options)</summary>

| Option | Type | Default |
|--------|------|---------|
| `audio.enable` | boolean | `false` |
| `bluetooth.enable` | boolean | `false` |
| `fonts.defaultFonts.emoji` | list of string | `["Noto Color Emoji"]` |
| `fonts.defaultFonts.monospace` | list of string | `["JetBrains Mono"]` |
| `fonts.defaultFonts.sansSerif` | list of string | `["Noto Sans","Noto Sans CJK SC"]` |
| `fonts.defaultFonts.serif` | list of string | `["Noto Serif","Noto Serif CJK SC"]` |
| `fonts.enable` | boolean | `false` |
| `fonts.nerdFonts` | list of string | `["jetbrains-mono","roboto-mono"]` |
| `fonts.packages` | list of string | `["roboto","noto-fonts","noto-fonts-cjk-sans","noto-fonts-cjk-serif","noto-fonts-color-emoji","jetbrains-mono"]` |
| `kmscon.enable` | boolean | `true` |
| `kmscon.font` | string | `"JetBrainsMono Nerd Font"` |
| `kmscon.fontPackage` | string | `"nerd-fonts.jetbrains-mono"` |
| `kmscon.fontSize` | signed integer | `14` |
| `logind.handleLidSwitch` | string | `"sleep"` |
| `logind.handlePowerKey` | string | `"suspend"` |
| `power.enable` | boolean | `false` |
| `power.handleLidSwitch` | string | `"suspend"` |
| `power.handlePowerKey` | string | `"suspend"` |

</details>

<details>
<summary>disko (2 options)</summary>

| Option | Type | Default |
|--------|------|---------|
| `diskPath` | string | `"/dev/sda"` |
| `swapSize` | string | `"16G"` |

</details>

<details>
<summary>gui [nixos] (80 options)</summary>

| Option | Type | Default |
|--------|------|---------|
| `extraPackages` | list of string | `[]` |
| `fcitx5.addons` | list of package | `[]` |
| `fcitx5.behavior.allowInputMethodForPassword` | boolean | `true` |
| `fcitx5.behavior.showPreeditForPassword` | boolean | `true` |
| `fcitx5.enable` | boolean | `false` |
| `fcitx5.hotkeys.activate` | string | `"VoidSymbol"` |
| `fcitx5.hotkeys.altTrigger` | string | `"Shift_L"` |
| `fcitx5.hotkeys.deactivate` | string | `"VoidSymbol"` |
| `fcitx5.hotkeys.trigger` | string | `"Control+space"` |
| `fcitx5.theme` | string | `"FluentDark-solid"` |
| `firefox.dnsOverHTTPS.enable` | boolean | `true` |
| `firefox.dnsOverHTTPS.providerURL` | string | `"https://1.1.1.1/dns-query"` |
| `firefox.enable` | boolean | `false` |
| `firefox.extraExtensions` | attribute set | `{}` |
| `firefox.extraPolicies` | attribute set | `{}` |
| `firefox.extraPreferences` | attribute set | `{}` |
| `firefox.proxy.enable` | boolean | `false` |
| `firefox.proxy.socksProxy` | string | `"127.0.0.1:1080"` |
| `firefox.proxy.socksVersion` | signed integer | `5` |
| `firefox.proxy.useProxyForDNS` | boolean | `true` |
| `foot.alpha` | floating point number | `0.65` |
| `foot.enable` | boolean | `false` |
| `foot.font` | string | `"JetBrainsMono Nerd Font:size=8"` |
| `foot.padding` | string | `"10x10 center"` |
| `fuzzel.borderRadius` | signed integer | `10` |
| `fuzzel.enable` | boolean | `false` |
| `fuzzel.fontSize` | signed integer | `12` |
| `fuzzel.padding` | signed integer | `12` |
| `fuzzel.width` | signed integer | `40` |
| `gtk.cursor.name` | string | `"Bibata-Modern-Ice"` |
| `gtk.cursor.package` | string | `"bibata-cursors"` |
| `gtk.cursor.size` | signed integer | `24` |
| `gtk.font` | string | `"Roboto 11"` |
| `gtk.icon.name` | string | `"Adwaita"` |
| `gtk.icon.package` | string | `"adwaita-icon-theme"` |
| `gtk.theme.name` | string | `"adw-gtk3-dark"` |
| `gtk.theme.package` | string | `"adw-gtk3"` |
| `gvfs.enable` | boolean | `true` |
| `mako.autostart` | boolean | `true` |
| `mako.backgroundColor` | string | `"#2e34407f"` |
| `mako.borderRadius` | signed integer | `12` |
| `mako.borderSize` | signed integer | `3` |
| `mako.defaultTimeout` | signed integer | `5000` |
| `mako.enable` | boolean | `false` |
| `mako.height` | signed integer | `120` |
| `mako.margin` | signed integer | `12` |
| `mako.maxIconSize` | signed integer | `64` |
| `mako.padding` | string | `"12,20"` |
| `mako.urgency.critical` | string | `"#bf616a"` |
| `mako.urgency.low` | string | `"#cccccc"` |
| `mako.urgency.normal` | string | `"#99c0d0"` |
| `mako.width` | signed integer | `420` |
| `niri.enable` | boolean | `false` |
| `niri.gtklock.blurRadius` | string | `"14x5"` |
| `niri.gtklock.clockFontSize` | signed integer | `72` |
| `niri.gtklock.enable` | boolean | `true` |
| `niri.gtklock.inputFieldFontSize` | signed integer | `14` |
| `niri.gtklock.inputFieldWidth` | signed integer | `280` |
| `niri.gtklock.wallpaper` | absolute path | `"/nix/store/y08srnph9jpsijfdj91rg1mmm132vnrx-lock.png"` |
| `niri.hotkey.launcher` | string | `"fuzzel"` |
| `niri.hotkey.lockscreen` | string | `"gtklock"` |
| `niri.hotkey.terminal` | string | `"foot"` |
| `niri.layout.cornerRadius` | signed integer | `10` |
| `niri.layout.focusRingColor` | string | `"#404040"` |
| `niri.layout.gaps` | signed integer | `6` |
| `niri.swaybg.enable` | boolean | `true` |
| `niri.swaybg.wallpaper` | absolute path | `"/nix/store/y1mk3y5hks1ajwgm4igdpcq91j0gvplv-bg.png"` |
| `niri.swayidle.enable` | boolean | `true` |
| `niri.swayidle.timeout` | signed integer | `900` |
| `niri.useNautilus` | boolean | `true` |
| `niri.username` | null or string | - |
| `tumbler.enable` | boolean | `true` |
| `waybar.autostart` | boolean | `true` |
| `waybar.enable` | boolean | `false` |
| `waybar.fontSize` | signed integer | `11` |
| `waybar.height` | signed integer | `24` |
| `waybar.margin.bottom` | signed integer | `0` |
| `waybar.margin.left` | signed integer | `6` |
| `waybar.margin.right` | signed integer | `6` |
| `waybar.margin.top` | signed integer | `6` |

</details>

<details>
<summary>lanzaboote [nixos] (1 options)</summary>

| Option | Type | Default |
|--------|------|---------|
| `pkiBundle` | string | `"/var/lib/sbctl"` |

</details>

<details>
<summary>preservation [nixos] (2 options)</summary>

| Option | Type | Default |
|--------|------|---------|
| `persistPath` | string | `"/persist"` |
| `users` | attribute set of (submodule) | `{}` |

</details>

<details>
<summary>proxy (5 options)</summary>

| Option | Type | Default |
|--------|------|---------|
| `singbox.configFile` | null or absolute path | - |
| `singbox.direct` | signed integer | `234` |
| `singbox.enable` | boolean | `false` |
| `singbox.mark` | signed integer | `233` |
| `singbox.table` | signed integer | `233` |

</details>

