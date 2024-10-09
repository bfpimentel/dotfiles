{ system, ... }:

let
  systemSpecificImports =
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
  ] ++ systemSpecificImports;
}
