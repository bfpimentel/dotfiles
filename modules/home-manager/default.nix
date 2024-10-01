{ system, ... }:

let
  linuxOnlyImports =
    if system != "aarch64-darwin" then
      [
        ./ssh
        ./zsh
      ]
    else
      [ ];
in
{
  imports = [
    ./neovim
    ./lazygit
  ] ++ linuxOnlyImports;
}
