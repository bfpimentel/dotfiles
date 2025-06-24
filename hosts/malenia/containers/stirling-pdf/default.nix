{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  stirlingPdfPaths =
    let
      root = "${vars.containersConfigRoot}/stirling-pdf";
    in
    {
      volumes = {
        inherit root;
        config = "${root}/config";
        customFiles = "${root}/custom-files";
        logs = "${root}/logs";
        pipeline = "${root}/pipeline";
        trainingData = "${root}/training-data";
      };
    };

  cfg = config.bfmp.containers.stirling-pdf;
in
{
  options.bfmp.containers.stirling-pdf = {
    enable = mkEnableOption "Enable StrilingPDF";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues stirlingPdfPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      stirling-pdf = {
        image = "stirlingtools/stirling-pdf:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [
          "${stirlingPdfPaths.volumes.config}:/configs"
          "${stirlingPdfPaths.volumes.customFiles}:/customFiles"
          "${stirlingPdfPaths.volumes.logs}:/logs"
          "${stirlingPdfPaths.volumes.pipeline}:/pipeline"
          "${stirlingPdfPaths.volumes.trainingData}:/usr/share/tessdata"
        ];
        environment = {
          DOCKER_ENABLE_SECURITY = "false";
          INSTALL_BOOK_AND_ADVANCED_HTML_OPS = "false";
          LANGS = "en_US,pt_BR";
        };
        labels = util.mkDockerLabels {
          id = "stirling-pdf";
          name = "StirlingPDF";
          subdomain = "pdf";
          port = 8080;
        };
      };
    };
  };
}
