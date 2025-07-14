{ lib, ... }:

{
  users.users = {
    postgres = {
      uid = lib.mkDefault 100001;
      isNormalUser = true;
    };
  };
}
