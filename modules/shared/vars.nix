{
  hostname,
  domain,
  externalDomain,
}:

{
  inherit hostname;

  # general
  timeZone = "America/Sao_Paulo";

  # user
  defaultUser = "bruno";
  defaultUserUID = 1000;
  defaultUserGID = 1000;
  defaultUserFullName = "Bruno Pimentel";
  defaultUserEmail = "hello@bruno.so";

  # networking
  wireguardInterface = "wg0";

  # hosts
  marikaIp = "10.22.4.10";
  maleniaIp = "10.22.4.2";
  radagonIp = "10.22.4.3";
  godwynIp = "10.22.4.4";
  miquellaIp = "159.112.184.83";

  # domains
  domain = domain;
  externalDomain = externalDomain;

  # configs
  servicesConfigRoot = "/persistent/opt/services";
  containersConfigRoot = "/persistent/opt/containers";
}
