{ lib, ... }:

{
  users.users = {
    postgres = {
      uid = lib.mkDefault 100001;
      isNormalUser = true;
    };
    grafana = {
      uid = lib.mkDefault 100002;
    };
  };
}
