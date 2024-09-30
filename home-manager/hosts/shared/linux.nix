{ username, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "bfpimentel";
        identityFile = "/home/${username}/.ssh/id_personal";
      };
    };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    shellAliases = {
      cdnix = "cd /etc/nixos";
      cnix = "nvim /etc/nixos";
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

      autoload -U colors && colors
      PS1="%{$fg[green]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
  };
}
