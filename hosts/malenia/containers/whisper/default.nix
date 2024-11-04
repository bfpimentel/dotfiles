{
  vars,
  username,
  ...
}:

let
  whisperPaths =
    let
      root = "${vars.containersConfigRoot}/whisper";
    in
    {
      volumes = {
        inherit root;
        cache = "${root}/cache";
      };
    };
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
    builtins.attrValues whisperPaths.volumes
  );

  virtualisation.oci-containers.containers = {
    whisper = {
      image = "onerahmet/openai-whisper-asr-webservice:latest-gpu";
      autoStart = true;
      extraOptions = [
        "--pull=newer"
        "--gpus=all"
      ];
      volumes = [ "${whisperPaths.volumes.cache}:/root/.cache/whisper" ];
      environment = {
        ASR_MODEL = "base";
        ASR_ENGINE = "openai_whisper";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.whisper.rule" = "Host(`whisper.${vars.domain}`)";
        "traefik.http.routers.whisper.entryPoints" = "https";
        "traefik.http.services.whisper.loadbalancer.server.port" = "9000";
      };
    };
  };
}
