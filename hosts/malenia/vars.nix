{
  # general
  timeZone = "America/Sao_Paulo";

  # networking
  ip = "10.22.4.2";
  defaultGateway = "10.22.4.1";
  networkInterface = "enp5s0";

  # domains
  domain = "local.luana.casa";
  externalDomain = "external.luana.casa";

  # configs
  servicesConfigRoot = "/persistent/opt/services";
  containersConfigRoot = "/persistent/opt/containers";

  # hosts
  godwynIp = "10.22.4.4";
  radagonIp = "10.22.4.3";
  miquellaIp = "159.112.184.83";

  # mounts
  mediaMountLocation = "/mnt/media";
  photosMountLocation = "/mnt/photos";
  documentsMountLocation = "/mnt/documents";

  # user
  defaultUserUID = 1000;
  defaultUserGID = 1000;
}
