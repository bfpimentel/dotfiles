{ util, config, ... }:

{
  home.file = util.linkSharedApp config "bat";
}
