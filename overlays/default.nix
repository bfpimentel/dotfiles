{ inputs, ... }: 

{
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
