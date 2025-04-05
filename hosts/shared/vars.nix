{
  system,
  hostname,
  username,
  fullname,
  email,
  domain,
  externalDomain,
}:

{
  # general
  system = system;
  hostname = hostname;
  timeZone = "America/Sao_Paulo";
  # user
  defaultUser = username;
  defaultUserUID = 1000;
  defaultUserGID = 1000;
  defaultUserFullName = fullname;
  defaultUserEmail = email;

  # networking
  wireguardInterface = "wg0";

  # hosts
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
