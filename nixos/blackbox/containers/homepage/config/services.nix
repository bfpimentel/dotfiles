domain: [
  {
    "Glances" = [
      {
        "Info" = {
          widget = {
            type = "glances";
            url = "http://host.containers.internal:61208";
            metric = "info";
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
            metric = "network:enp6s18";
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
