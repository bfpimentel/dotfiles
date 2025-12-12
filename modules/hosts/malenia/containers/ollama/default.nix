{
  config,
  lib,
  pkgs,
  vars,
  util,
  ...
}:

with lib;
let
  ollamaPaths = {
    volumes = {
      ollama = "${vars.containersConfigRoot}/ollama";
      webui = "${vars.containersConfigRoot}/ollama-webui";
    };
  };

  cfg = config.bfmp.containers.ollama;
in
{
  options.bfmp.containers.ollama = {
    enable = mkEnableOption "Enable Ollama";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues ollamaPaths.volumes
    );

    environment.systemPackages = with pkgs; [ ollama ];

    virtualisation.oci-containers.containers = {
      ollama = {
        image = "ollama/ollama:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        devices = [ "nvidia.com/gpu=all" ];
        volumes = [ "${ollamaPaths.volumes.ollama}:/root/.ollama" ];
        labels = util.mkDockerLabels {
          id = "ollama";
          name = "Ollama";
          subdomain = "ollama";
          port = 11434;
        };
      };
      ollama-webui = {
        image = "ghcr.io/open-webui/open-webui:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [ "${ollamaPaths.volumes.webui}:/app/backend/data" ];
        # environmentFiles = [ config.age.secrets.ollama-webui.path ];
        environment = {
          OLLAMA_BASE_URL = "https://ollama.${vars.domain}";
          # ENABLE_OAUTH_SIGNUP = "false";
          # OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
          # OAUTH_PROVIDER_NAME = "Authentik";
        };
        labels = util.mkDockerLabels {
          id = "open-webui";
          name = "Ollama WebUI";
          subdomain = "chat";
          port = 8080;
        };
      };
    };
  };
}
