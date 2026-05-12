{ ... }:

{
  config.bfmp.hm.sharedModules = [
    (
      { pkgs, util, ... }:
      {
        home.packages = with pkgs; [
          nh

          bun
          nodejs_25

          antidote
          oh-my-posh

          curl
          git
          lazygit
          wget
          uv

          fastfetch
          fzf
          gnupg
          libpcap
          ripgrep

          lua

          opencode
        ];
      }
    )
  ];

  config.bfmp.hm.hosts.seraphim.modules = [
    (
      { pkgs, ... }:
      let
        casks = with pkgs.brewCasks; [
          # Custom Taps
          aerospace
          # tuna # Not working right now. Installed manually.

          altserver
          betterdisplay
          bruno
          codex-app
          helium-browser
          hiddenbar
          kitty
          lm-studio
          moonlight
          pearcleaner
          shottr
          the-unarchiver
          vial
          wallspace
          xcodes-app

          (anydesk.overrideAttrs (oldAttrs: {
            src = pkgs.fetchurl {
              url = builtins.head oldAttrs.src.urls;
              hash = "sha256-LLq0NjqBe7CCb31ksYn5VkBLVF98GSlV5AOb9H5ihhU=";
            };
          }))
          (ankerwork.overrideAttrs (oldAttrs: {
            src = pkgs.fetchurl {
              url = builtins.head oldAttrs.src.urls;
              hash = "sha256-1Wo7ZPJdrsf01NQbQsFAh+kCRJSexSC/vX3vyy+qFD0=";
            };
          }))
        ];
      in
      {
        home.packages =
          with pkgs;
          [
            tmux
            rsync
            direnv
            jankyborders

            nerd-fonts.symbols-only
            nerd-fonts.victor-mono
            nerd-fonts.iosevka
          ]
          ++ casks;
      }
    )
  ];

  config.bfmp.hm.hosts.cherubim.modules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          zsh

          bitwarden-cli
          mcporter

          kitty

          hypridle
          hyprland
          hyprlock
          hyprpaper
          hyprpwcenter

          cliphist
          grim
          libnotify
          playerctl
          quickshell
          satty
          slurp
          wl-clipboard

          xdg-desktop-portal
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland

          peazip
          ungoogled-chromium
          vial

          podman
          podman-compose

          kdePackages.dolphin

          qt6.qtbase
          qt6.qtdeclarative
          qt6.qttools

          hanken-grotesk
          nerd-fonts.symbols-only
          nerd-fonts.victor-mono
          nerd-fonts.iosevka
        ];
      }
    )
  ];

  config.bfmp.hm.hosts.powers.modules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          zsh
        ];
      }
    )
  ];

  config.bfmp.hm.hosts.thronos.modules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          zsh
        ];
      }
    )
  ];
}
