{ util, config, ... }:

{
  home.file = util.linkHostApp config "sunshine";
}
