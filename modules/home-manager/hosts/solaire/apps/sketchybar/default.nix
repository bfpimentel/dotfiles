{
  pkgs,
  util,
  config,
  ...
}:

{
  programs.sketchybar = {
    enable = true;
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
