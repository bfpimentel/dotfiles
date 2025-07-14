{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
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

  cfg = config.bfmp.containers.whisper;
in
{
  options.bfmp.containers.whisper = {
    enable = mkEnableOption "Enable Whisper";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues whisperPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      whisper = {
        image = "onerahmet/openai-whisper-asr-webservice:latest-gpu";
        autoStart = true;
        extraOptions = [
          "--pull=always"
          "--device nvidia.com/gpu=all"
        ];
        networks = [ "local" ];
        volumes = [ "${whisperPaths.volumes.cache}:/root/.cache/whisper" ];
        environment = {
          ASR_MODEL = "base";
          ASR_ENGINE = "openai_whisper";
        };
        labels = util.mkDockerLabels {
          id = "whisper";
          name = "Whisper";
          subdomain = "whisper";
          port = 9000;
        };
      };
    };
  };
}
