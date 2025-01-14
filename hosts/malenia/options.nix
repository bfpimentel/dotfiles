{
  lib,
  username,
  hostname,
  ...
}:

with lib;
{
  options.bfmp.malenia.vars = {
    # general
    hostname = mkOption {
      default = hostname;
      type = types.str;
    };
    timeZone = mkOption {
      default = "America/Sao_Paulo";
      type = types.str;
    };

    # user
    defaultUser = mkOption {
      default = username;
      type = types.str;
    };
    defaultUserUID = mkOption {
      default = 1000;
      type = types.int;
    };
    defaultUserGID = mkOption {
      default = 1000;
      type = types.int;
    };

    # networking
    defaultIp = mkOption {
      default = "10.22.4.2";
      type = types.str;
    };
    defaultGateway = mkOption {
      default = "10.22.4.1";
      type = types.str;
    };
    networkInterface = mkOption {
      default = "enp5s0";
      type = types.str;
    };
    wireguardInterface = mkOption {
      default = "wg0";
      type = types.str;
    };

    # domains
    domain = mkOption {
      default = "local.luana.casa";
      type = types.str;
    };
    externalDomain = mkOption {
      default = "external.luana.casa";
      type = types.str;
    };

    # hosts
    godwynIp = mkOption {
      default = "10.22.4.4";
      type = types.str;
    };
    radagonIp = mkOption {
      default = "10.22.4.3";
      type = types.str;
    };
    miquellaIp = mkOption {
      default = "159.112.184.83";
      type = types.str;
    };

    # configs
    servicesConfigRoot = mkOption {
      default = "/persistent/opt/services";
      type = types.str;
    };
    containersConfigRoot = mkOption {
      default = "/persistent/opt/containers";
      type = types.str;
    };

    # mounts
    mediaMountLocation = mkOption {
      default = "/mnt/media";
      type = types.str;
    };
    photosMountLocation = mkOption {
      default = "/mnt/photos";
      type = types.str;
    };
    documentsMountLocation = mkOption {
      default = "/mnt/documents";
      type = types.str;
    };
  };
}
