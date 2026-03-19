{ pkgs, ... }:

let
  tuna = pkgs.stdenv.mkDerivation {
    pname = "tuna";
    version = "latest";

    src = pkgs.fetchurl {
      url = "https://tunaformac.com/download/latest";
      sha256 = "sha256-zH4a0yShyS5w5ugo8Gy5oTfHlEVC2eA1+UWz3PvPnfI=";
    };

    nativeBuildInputs = [ pkgs.unzip ];

    sourceRoot = ".";

    unpackPhase = ''
      ${pkgs.unzip}/bin/unzip $src -d source
    '';

    installPhase = ''
      mkdir -p "$out/Applications"
      cp -pR "source/Tuna.app" "$out/Applications/"
    '';
  };
in
{
  home.packages = [ tuna ];
}
