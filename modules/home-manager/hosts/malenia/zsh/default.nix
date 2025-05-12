{ pkgs, ... }:

{
  programs.zsh = {
    envExtra = ''
      export JAVA_HOME=${pkgs.zulu17}
      PATH="PATH:${pkgs.zulu17}/bin"
    '';
  };
}
