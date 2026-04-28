{ ... }:

{
  config.bfmp.hm.nixpkgsConfig = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "openclaw-2026.4.12"
    ];
  };
}
