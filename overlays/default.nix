{ inputs, ... }:

{
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = final: prev: {
    slirp4netns = prev.slirp4netns.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [ ./slirp4netns.patch ];
    });
  };
}
