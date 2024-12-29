{ vars, ... }:

{
  networking.nat = {
    enable = true;
    externalInterface = vars.networkInterface;
    internalInterfaces = [ vars.wireguardInterface ];
  };
}
