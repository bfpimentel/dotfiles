{ username, ... }:

{
  imports = [ (./. + "/users/${username}.nix") ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    shellAliases = {
      cdn = "cd /etc/nixos";
      rnix = "sudo nixos-rebuild switch --impure";
      vim = "nvim";
      gst = "git status -sb";
      gf = "git fetch";
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    initExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
  };
}
