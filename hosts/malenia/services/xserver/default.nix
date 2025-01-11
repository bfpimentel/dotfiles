{ username, ... }:

{
  services.xserver = {
    videoDrivers = [ "nvidia" ];

    xkb = {
      layout = "en";
      variant = "qwerty";
    };

    desktopManager.gnome.enable = true;

    displayManager.gdm.enable = true;
  };

  services.displayManager = {
    defaultSession = "gnome";
    autoLogin.enable = true;
    autoLogin.user = username;
  };
}
