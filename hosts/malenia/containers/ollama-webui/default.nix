{
  vars,
  username,
  config,
  ...
}:

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
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
    builtins.attrValues ollamaWebUiPaths.volumes
  );

  virtualisation.oci-containers.containers = {
    ollama-webui = {
      image = "ghcr.io/open-webui/open-webui:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [ "${ollamaWebUiPaths.volumes.root}:/app/backend/data" ];
      environmentFiles = [ config.age.secrets.ollama-webui.path ];
      environment = {
        OLLAMA_BASE_URL = "https://ollama.${vars.domain}";
        ENABLE_OAUTH_SIGNUP = "false";
        OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
        OAUTH_PROVIDER_NAME = "Authentik";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.ollama-webui.rule" = "Host(`chat.${vars.domain}`)";
        "traefik.http.routers.ollama-webui.entryPoints" = "https";
        "traefik.http.services.ollama-webui.loadbalancer.server.port" = "8080";
        # Homepage
        "homepage.group" = "Misc";
        "homepage.name" = "Ollama Web UI";
        "homepage.icon" = "ollama.svg";
        "homepage.href" = "https://chat.${vars.domain}";
      };
    };
  };
}
