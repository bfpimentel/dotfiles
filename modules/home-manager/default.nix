{ system, ... }:

let
  systemSpecificImports = if system == "aarch64-darwin" then [ ] else [ ];
in
{
  imports = [
    ./neovim
    ./lazygit
    ./zsh
    ./bat
    ./ssh
  ] ++ systemSpecificImports;
}
