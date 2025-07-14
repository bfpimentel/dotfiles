{ pkgs, ... }:

{
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixPath = [ "nixos-config=/etc/nixos" ];
  };

  environment.pathsToLink = [ "/etc/profile" ];

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl suspend";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/poweroff";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
    extraConfig = with pkgs; ''
      Defaults:picloud secure_path="${
        lib.makeBinPath [
          systemd
        ]
      }:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
    '';
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/etc/nixos";
  };
}
