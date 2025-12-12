{ vars, ... }:

{
  imports = [
    ./services
  ];

  networking = {
    hostName = vars.hostname;
    localHostName = vars.hostname;
  };

  users.users.${vars.defaultUser}.home = "/Users/${vars.defaultUser}";

  system.stateVersion = 4;
}
