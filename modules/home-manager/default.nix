{ system, ... }:

let
  systemSpecificImports =
    if system != "aarch64-darwin" then
      [
        ./ssh
      ]
    else
      [ ];
in
{
  imports = [
    ./neovim
    ./lazygit
    ./zsh
    ./bat
  ] ++ systemSpecificImports;
}
