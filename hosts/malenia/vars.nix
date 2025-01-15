{
  # networking
  ip = "10.22.4.2";
  defaultGateway = "10.22.4.1";
  networkInterface = "enp5s0";

  # configs
  servicesConfigRoot = "/persistent/opt/services";
  containersConfigRoot = "/persistent/opt/containers";

  # mounts
  mediaMountLocation = "/mnt/media";
  photosMountLocation = "/mnt/photos";
  documentsMountLocation = "/mnt/documents";
}
