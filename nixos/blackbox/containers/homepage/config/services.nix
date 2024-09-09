domain: networkInterface: [
  {
    "Glances" = [
      {
        "Info" = {
          widget = {
            type = "glances";
            url = "https://glances.${domain}";
            metric = "info";
            version = 4;
          };
        };
      }
      {
        "Temp" = {
          widget = {
            type = "glances";
            url = "https://glances.${domain}";
            metric = "sensor:Tctl";
            version = 4;
          };
        };
      }
      {
        "Storage" = {
          widget = {
            type = "glances";
            url = "https://glances.${domain}";
            metric = "process";
            version = 4;
          };
        };
      }
      {
        "Network" = {
          widget = {
            type = "glances";
            url = "https://glances.${domain}";
            metric = "network:${networkInterface}";
            chart = true;
            version = 4;
          };
        };
      }
    ];
  }
  { "Media" = [ ]; }
  { "Download Managers" = [ ]; }
  { "Documents" = [ ]; }
  { "Misc" = [ ]; }
  { "Monitoring" = [ ]; }
  { "Auth" = [ ]; }
  { "Networking" = [ ]; }
]
