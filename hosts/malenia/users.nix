{ lib, ... }:

{
  users.users = {
    postgres = {
      uid = lib.mkDefault 100001;
      isNormalUser = true;
    };
    # sunshine = {
    #   isNormalUser = true;
    #   home = "/home/sunshine";
    #   description = "Sunshine Server";
    #   extraGroups = [
    #     "wheel"
    #     "networkmanager"
    #     "input"
    #     "video"
    #     "sound"
    #   ];
    #   openssh.authorizedKeys.keys = [
    #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEQfvoGzi0djr8CsbGuBR3LwHXQyd4gj5geArDwo1d5 bruno@pimentel.dev"
    #   ];
    # };
  };
}
