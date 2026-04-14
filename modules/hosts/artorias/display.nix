{ ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.xserver.enable = false;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "colormix";
      bigclock = "en";
      brightness_down_key = "null";
      brightness_up_key = "null";
      clear_password = true;
      cmatrix_fg = "0x005A4A2A";
      cmatrix_head_col = "0x00D4A574";
      colormix_col1 = "0x003D2B1F";
      colormix_col2 = "0x007A8A9A";
      colormix_col3 = "0x00E6C88A";
      hide_borders = true;
      hide_key_hints = true;
      hide_keyboard_locks = true;
      hide_version_string = true;
      margin_box_h = 2;
      margin_box_v = 2;
    };
  };
}
