{
  util,
  config,
  ...
}:

{
  home.file = util.linkHostApp config "tmux";
}
