{
  title = "bruno's lab";
  headerStyle = "clean";
  statusStyle = "dot";
  theme = "dark";
  useEqualHeights = true;
  hideVersion = true;
  background = {
    image = "/images/background.gif";
    blur = "sm";
    brightness = 50;
  };
  layout = [
    {
      "Glances" = {
        header = false;
        style = "row";
        columns = 4;
      };
    }
    {
      "Media" = {
        style = "row";
        columns = 4;
      };
    }
    {
      "Media Managers" = {
        style = "row";
        columns = 4;
      };
    }
    { "Download Managers" = { }; }
    { "Documents" = { }; }
    { "Misc" = { }; }
    { "Monitoring" = { }; }
    {
      "Auth" = {
        style = "row";
        columns = 4;
      };
    }
    {
      "Networking" = {
        style = "row";
        columns = 4;
      };
    }
    {
      "Management" = {
        style = "row";
        columns = 4;
      };
    }
  ];
}
