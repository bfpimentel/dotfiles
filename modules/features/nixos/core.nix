{ ... }:

{
  config.bfmp.nixos.sharedModules = [
    (
      { ... }:
      {
        nix = {
          settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          nixPath = [ "nixos-config=/home/bruno/.dotfiles" ];
        };
      }
    )
  ];
}
