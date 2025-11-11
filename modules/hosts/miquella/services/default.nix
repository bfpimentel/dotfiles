{ vars, ... }:

{
  imports = [
    ./headscale
    ./wireguard
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = vars.defaultUserEmail;
  };

  services.nginx = {
    enable = true;
    user = vars.defaultUser;
  };
}
