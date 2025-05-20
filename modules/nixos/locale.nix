{
  config,
  lib,
  pkgs,
  ...
}:

{
  time.timeZone = "America/Sao_Paulo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  console.keyMap = "us-acentos";
}
