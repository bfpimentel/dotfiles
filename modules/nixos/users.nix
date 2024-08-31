{
  config,
  libs,
  pkgs,
  username,
  fullname,
  ...
}:

{
  users.groups = {
    "${username}" = {
      gid = 1000;
    };
    media = {
      gid = 1001;
    };
    storage = {
      gid = 2000;
    };
    podman = {
      gid = 994;
    };
  };

  users.users = {
    "${username}" = {
      uid = 1000;
      group = "${username}";
      description = "${fullname}";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "podman"
        "storage"
        "media"
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEQfvoGzi0djr8CsbGuBR3LwHXQyd4gj5geArDwo1d5 bruno@pimentel.dev"
      ];
    };
    media = {
      uid = 1001;
      group = "media";
      isNormalUser = true;
      extraGroups = [ "storage" ];
    };
    storage = {
      uid = 2000;
      group = "storage";
      isNormalUser = true;
    };
  };
}
