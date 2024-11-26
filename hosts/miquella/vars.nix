{
  # general
  timeZone = "America/Sao_Paulo";

  # networking
  ip = "10.0.0.57";
  defaultGateway = "10.0.0.1";
  networkInterface = "enp0s6";

  # domains
  domain = "external.luana.casa";

  # hosts
  maleniaIp = "10.22.4.2";

  # configs
  servicesConfigRoot = "/persistent/opt/services";
  containersConfigRoot = "/persistent/opt/containers";

  # user
  defaultUserUID = 1000;
  defaultUserGID = 1000;
}
