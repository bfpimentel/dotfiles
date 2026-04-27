{ ... }:

{
  config.bfmp.nixos.commonModules = [
    ({ ... }: {
      nix = {
        settings.experimental-features = [
          "nix-command"
          "flakes"
        ];

        nixPath = [ "nixos-config=/home/bruno/.dotfiles" ];
      };
    })
  ];
}
