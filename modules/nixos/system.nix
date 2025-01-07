{ ... }:

{
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixPath = [ "nixos-config=/etc/nixos" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
