{ util, config, ... }:

{
  home.file = util.linkHostApp config "hypr";
}
