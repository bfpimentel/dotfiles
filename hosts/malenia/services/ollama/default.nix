{
  pkgs,
  username,
  vars,
  ...
}:

let
  ollamaPath = "${vars.servicesConfigRoot}/ollama";

  directories = [
    "${ollamaPath}"
    "${ollamaPath}/data"
    "${ollamaPath}/models"
  ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  systemd.services.ollama.serviceConfig = {
    User = username;
  };

  services.ollama = {
    enable = true;
    openFirewall = true;
    package = pkgs.ollama;
    host = "0.0.0.0";
    port = 11434;
    acceleration = "cuda";
    home = "${ollamaPath}/data";
    models = "${ollamaPath}/models";
    loadModels = [
      "llama3.2:3b"
    ];
    environmentVariables = {
      OLLAMA_ORIGINS = "http://localhost:11434,https://ollama.local.luana.casa";
    };
  };
}
