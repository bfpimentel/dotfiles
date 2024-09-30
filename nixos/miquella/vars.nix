{
  # general
  ip = "10.0.0.57";
  networkInterface = "enp0s6";
  timeZone = "America/Sao_Paulo";

  # domains
  domain = "external.luana.casa";

  # configs
  servicesConfigRoot = "/persistent/opt/services";
  containersConfigRoot = "/persistent/opt/containers";

  # user
  defaultUserUID = 1000;
  defaultUserGID = 1000;
}
