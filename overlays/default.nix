{ inputs, pkgs, ... }:

{
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = final: prev: {
    neovim = inputs.neovim-nightly.overlays.default;
    slirp4netns = prev.slirp4netns.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [ ./patches/slirp4netns.patch ];
    });
  };
}
