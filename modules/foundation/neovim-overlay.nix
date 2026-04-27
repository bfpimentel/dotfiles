{ inputs, ... }:

{
  config.bfmp.hm.overlays = [
    inputs.neovim-nightly.overlays.default
  ];
}
