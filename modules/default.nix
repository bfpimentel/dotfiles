{ lib, ... }:

let
  nixFiles = builtins.filter (
    path:
    lib.hasSuffix ".nix" (toString path)
    && builtins.baseNameOf (toString path) != "default.nix"
  ) (lib.filesystem.listFilesRecursive ./.);
in
{
  imports = nixFiles;
}
