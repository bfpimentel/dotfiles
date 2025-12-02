{
  pkgs,
  ...
}:

{
  programs.sketchybar = {
    enable = false;
    configType = "lua";
    config = {
      source = ./config;
      recursive = true;
    };
  };

  home = {
    packages = with pkgs; [
      sketchybar-app-font
    ];
    # file = util.linkHostApp config "sketchybar";
  };
}
