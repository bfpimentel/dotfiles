{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      {
        lib,
        modulesPath,
        ...
      }:
      { }
    )
  ];
}
