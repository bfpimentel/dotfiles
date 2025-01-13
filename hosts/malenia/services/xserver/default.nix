{ pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    xorg.xrandr
  ];

  security.rtkit.enable = true;

  services.xserver = {
    videoDrivers = [ "nvidia" ];

    # xkb = {
    #   layout = "en";
    #   variant = "qwerty";
    # };
    #
    # desktopManager.gnome.enable = true;
    #
    # displayManager.gdm = {
    #   enable = true;
    #   autoSuspend = false;
    # };
    #
    # deviceSection = ''
    #   VendorName      "NVIDIA Corporation"
    #   Option          "AllowEmptyInitialConfiguration"
    #   Option          "ConnectedMonitor" "DFP"
    #   Option          "CustomEDID" "DFP-0"
    # '';
    #
    # monitorSection = ''
    #   Identifier      "Configured Monitor"
    #   HorizSync       30-85
    #   VertRefresh     48-120
    # '';
    #
    # screenSection = ''
    #   Identifier      "Default Screen"
    #   DefaultDepth    24
    #   Option          "ModeValidation" "AllowNonEdidModes, NoVesaModes"
    #   Option          "MetaModes" "1920x1080"
    #   SubSection      "Display"
    #       Depth       24
    #       Modes       "1920x1080"
    #   EndSubSection
    # '';
  };

  # services.displayManager = {
  #   defaultSession = "gnome";
  #   autoLogin = {
  #     enable = true;
  #     user = username;
  #   };
  # };
}
