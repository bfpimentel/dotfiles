{ ... }:

{
  config.bfmp.nixos.sharedModules = [
    (
      { ... }:
      {
        nix.settings.trusted-users = [ "bruno" ];

        users.users.bruno = {
          isNormalUser = true;
          description = "Bruno Pimentel";
          extraGroups = [
            "wheel"
            "video"
            "input"
            "podman"
          ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfTMOZqQ5tMiLG7GmhkhZrwgzpD2cPuQAuqAnG24qHw hello@bruno.so"
          ];
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
