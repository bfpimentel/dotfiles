{
  config,
  lib,
  ...
}:

with lib;
let
  inherit (config.bfmp.malenia) vars;

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
        extraOptions = [ "--pull=newer" ];
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
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.stirling-pdf.rule" = "Host(`pdf.${vars.domain}`)";
          "traefik.http.routers.stirling-pdf.entryPoints" = "https";
          "traefik.http.services.stirling-pdf.loadbalancer.server.port" = "8080";
          # Homepage
          "homepage.group" = "Documents";
          "homepage.name" = "Stirling PDF";
          "homepage.icon" = "stirling-pdf.svg";
          "homepage.href" = "https://pdf.${vars.domain}";
        };
      };
    };
  };
}
