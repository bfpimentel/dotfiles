{
  config,
  libs,
  pkgs,
  ...
}:

{
  virtualisation.docker = {
    enable = true;
  };
}
