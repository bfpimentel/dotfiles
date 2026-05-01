let
  bruno = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfTMOZqQ5tMiLG7GmhkhZrwgzpD2cPuQAuqAnG24qHw hello@bruno.so";
in
{
  "hermes-env.age".publicKeys = [ bruno ];
  "hermes-auth.age".publicKeys = [ bruno ];
}
