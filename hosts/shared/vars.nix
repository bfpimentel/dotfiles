system: hostname: username: fullname: email: {
  # general
  system = system;
  hostname = hostname;
  timeZone = "America/Sao_Paulo";

  # networking
  wireguardInterface = "wg0";

  # user
  defaultUser = username;
  defaultUserUID = 1000;
  defaultUserGID = 1000;
  defaultUserFullName = fullname;
  defaultUserEmail = email;

  # domains
  domain = "local.luana.casa";
  externalDomain = "external.luana.casa";

  # hosts
  maleniaIp = "10.22.4.2";
  radagonIp = "10.22.4.3";
  godwynIp = "10.22.4.4";
  miquellaIp = "159.112.184.83";
}
