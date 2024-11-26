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
  {
    "Media" = [
      # {
      #   "Jellyfin" = {
      #     icon = "jellyfin";
      #     href = "https://media.${domain}";
      #     weight = 5;
      #     widget = {
      #       type = "jellyfin";
      #       url = "https://media.${domain}";
      #       key = "{{HOMEPAGE_VAR_JELLYFIN_KEY}}";
      #     };
      #   };
      # }
      {
        "Plex" = {
          icon = "plex";
          href = "https://media.${domain}";
          weight = 6;
          widget = {
            type = "tautulli";
            url = "http://tautulli:8181";
            key = "{{HOMEPAGE_VAR_PLEX_KEY}}";
            enableUser = true;
          };
        };
      }
    ];
  }
  { "Media Managers" = [ ]; }
  { "Download Managers" = [ ]; }
  { "Documents" = [ ]; }
  { "Misc" = [ ]; }
  {
    "Monitoring" = [
      {
        "Grafana" = {
          icon = "grafana";
          href = "https://grafana.${domain}";
          weight = 50;
        };
      }
    ];
  }
  {
    "Management" = [
      {
        "Home Assistant" = {
          icon = "home-assistant-alt";
          href = "https://home.${domain}";
        };
      }
      {
        "Unraid" = {
          icon = "unraid";
          href = "https://storage.${domain}";
        };
      }
    ];
  }
  {
    "Networking" = [
      {
        "Unifi Console" = {
          icon = "unifi";
          href = "https://unifi.ui.com";
        };
      }
    ];
  }
]
