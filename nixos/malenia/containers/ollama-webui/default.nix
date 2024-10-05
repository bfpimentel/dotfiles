{ vars, username, ... }:

let
  ollamaWebUiPath = "${vars.containersConfigRoot}/ollama-webui";

  directories = [
    ollamaWebUiPath
  ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers.containers = {
    ollama-webui = {
      image = "ghcr.io/open-webui/open-webui:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [ "${ollamaWebUiPath}:/app/backend/data" ];
      environment = {
        OLLAMA_BASE_URL = "https://ollama.${vars.domain}";
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
