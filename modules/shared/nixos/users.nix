{
  vars,
  ...
}:

{
  users.groups = {
    "${vars.defaultUser}" = {
      gid = vars.defaultUserGID;
    };
    podman = {
      gid = 994;
    };
    postgres = { };
  };

  users.users = {
    "${vars.defaultUser}" = {
      uid = vars.defaultUserUID;
      group = "${vars.defaultUser}";
      description = "${vars.defaultUserFullName}";
      isNormalUser = true;
      # shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "podman"
        "docker"
        "wheel"
        "postgres"
        "grafana"
        "render"
        "video"
        "audio"
        "input"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfTMOZqQ5tMiLG7GmhkhZrwgzpD2cPuQAuqAnG24qHw hello@bruno.so"
      ];
    };
  };
}
