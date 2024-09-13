{
  domain = "local.luana.casa";
  ip = "10.22.4.2";
  networkInterface = "enp5s0";
  timeZone = "America/Sao_Paulo";

  # configs
  servicesConfigRoot = "/persistent/opt/services";
  containersConfigRoot = "/persistent/opt/containers";

  # mounts
  unraidIp = "10.22.4.4";
  mediaMountLocation = "/mnt/media";
  photosMountLocation = "/mnt/photos";
  containersMountLocation = "/mnt/containers";

  # user
  defaultUserUID = 1000;
  defaultUserGID = 1000;
}
