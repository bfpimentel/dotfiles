{
  config,
  lib,
  pkgs,
  username,
  ...
}:

{
  age = {
    identityPaths = [
      "/root/.ssh/id_system"
      "/home/${username}/.ssh/id_personal"
    ];
    secrets = {
      share.file = ../../secrets/share.age;
      cloudflare.file = ../../secrets/cloudflare.age;
    };
  };
}
