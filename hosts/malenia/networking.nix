{ vars, ... }:

{
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.networkmanager.enable = true;
}
