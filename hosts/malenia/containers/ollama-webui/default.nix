{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  ollamaWebUiPaths =
    let
      root = "${vars.containersConfigRoot}/ollama-webui";
    in
    {
      volumes = {
        inherit root;
      };
    };

  cfg = config.bfmp.containers.ollama-webui;
in
{
  options.bfmp.containers.ollama-webui = {
    enable = mkEnableOption "Enable Ollama WebUI";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues ollamaWebUiPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      ollama-webui = {
        image = "ghcr.io/open-webui/open-webui:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [ "${ollamaWebUiPaths.volumes.root}:/app/backend/data" ];
        environmentFiles = [ config.age.secrets.ollama-webui.path ];
        environment = {
          OLLAMA_BASE_URL = "https://ollama.${vars.domain}";
          ENABLE_OAUTH_SIGNUP = "false";
          OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
          OAUTH_PROVIDER_NAME = "Authentik";
        };
        labels = util.mkDockerLabels {
          id = "open-webui";
          icon = "ollama";
          name = "Ollama WebUI";
          subdomain = "chat";
          port = 8080;
        };
      };
    };
  };
}
