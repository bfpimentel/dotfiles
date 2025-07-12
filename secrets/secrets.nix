let
  bruno = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfTMOZqQ5tMiLG7GmhkhZrwgzpD2cPuQAuqAnG24qHw hello@bruno.so";
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANlcb4fXObPYgNu1Yo805CTCc/6IIdVgHidClVWWBoK hello@bruno.so";

  authorizedKeys = [
    bruno
    system
  ];

  files = import ./files.nix;
in
builtins.listToAttrs (
  builtins.map (file: {
    name = file;
    value.publicKeys = authorizedKeys;
  }) files
)
