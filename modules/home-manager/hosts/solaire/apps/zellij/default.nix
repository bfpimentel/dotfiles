{
  util,
  config,
  ...
}:

{
  home.file = util.linkHostApp config "zellij";
}
