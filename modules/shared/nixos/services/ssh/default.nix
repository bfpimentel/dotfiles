{ ... }:

{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 3;
      TCPKeepAlive = "yes";
    };
  };
}
