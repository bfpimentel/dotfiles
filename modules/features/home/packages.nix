{ inputs, ... }:

{
  config.bfmp.hm.sharedModules = [
    (
      { pkgs, util, ... }:
      {
        home.packages = with pkgs; [
          nh

          bun
          nodejs_22

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
        ];
      }
    )
  ];

  config.bfmp.hm.hosts.seraphim.modules = [
    (
      { pkgs, ... }:
      let
        casks = with pkgs.brewCasks; [
          altserver
          bettercapture
          bruno
          codex-app
          ghostty
          helium-browser
          hiddenbar
          kitty
          pearcleaner
          shottr
          the-unarchiver
          vial
          xcodes-app

          (anydesk.overrideAttrs (oldAttrs: {
            src = pkgs.fetchurl {
              url = builtins.head oldAttrs.src.urls;
              hash = "sha256-6BApi8XV8T+Th4jOejQqfN0Sz/EF7HNHUtXC9O5egCI=";
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
            inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
            inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.herdr

            aerospace
            jankyborders

            tmux
            rsync
            direnv
            pnpm

            # podman
            # podman-compose

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
