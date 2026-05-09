{ ... }:

{
  config.bfmp.nixos.sharedModules = [
    (
      { pkgs, ... }:
      {
        programs.zsh.enable = true;

        nix.settings.trusted-users = [ "bruno" ];

        users = {
          groups.bruno = {
            gid = 1000;
          };

          users.bruno = {
            isNormalUser = true;
            group = "bruno";
            description = "Bruno Pimentel";
            shell = pkgs.zsh;
            extraGroups = [
              "wheel"
              "video"
              "input"
              "podman"
              "postgres"
            ];
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfTMOZqQ5tMiLG7GmhkhZrwgzpD2cPuQAuqAnG24qHw hello@bruno.so"
            ];
          };
        };
        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";
            AllowUsers = [ "bruno" ];
          };
        };
      }
    )
  ];
}
