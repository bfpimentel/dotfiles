{ pkgs, ... }:

let
  pencil = pkgs.stdenv.mkDerivation {
    pname = "pencil";
    version = "latest";

    src = pkgs.fetchurl {
      url = "https://www.pencil.dev/download/Pencil-mac-arm64.dmg";
      sha256 = "sha256-OYuh7ALo7vJ4wm3F+2b7bsDvMlonCaply2uiaaVWjU0=";
    };

    unpackPhase = ''
      runHook preUnpack

      mountPoint="$PWD/mnt"
      mkdir -p "$mountPoint"

      /usr/bin/hdiutil attach -nobrowse -readonly -mountpoint "$mountPoint" "$src"
      cp -pR "$mountPoint/Pencil.app" "$PWD/"
      /usr/bin/hdiutil detach "$mountPoint"

      runHook postUnpack
    '';

    installPhase = ''
      mkdir -p "$out/Applications"
      cp -pR "./Pencil.app" "$out/Applications/"
    '';
  };
in
{
  home.packages = [ pencil ];
}
