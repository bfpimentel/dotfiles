{
  pkgs,
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
  };

  users.users = {
    "${vars.defaultUser}" = {
      uid = vars.defaultUserUID;
      group = "${vars.defaultUser}";
      description = "${vars.defaultUserFullName}";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "podman"
        "wheel"
        "postgres"
        "grafana"
        "render"
        "video"
        "audio"
        "input"
        "plex"
      ];
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfTMOZqQ5tMiLG7GmhkhZrwgzpD2cPuQAuqAnG24qHw hello@bruno.so"
      ];
    };
  };
}
