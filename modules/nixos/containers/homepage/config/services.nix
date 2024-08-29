[
  {
    "Glances" = [
      {
        "Info" = {
          widget = {
            type = "glances";
            url = "http://10.22.4.20:61208";
            metric = "info";
          };
        };
      }
      {
        "CPU Temp" = {
          widget = {
            type = "glances";
            url = "http://10.22.4.20:61208";
            metric = "sensor:Tctl";
          };
        };
      }
      {
        "Storage" = {
          widget = {
            type = "glances";
            url = "http://10.22.4.20:61208";
            metric = "process";
          };
        };
      }
      {
        "Network" = {
          widget = {
            type = "glances";
            url = "http://10.22.4.20:61208";
            metric = "network:enp6s18";
            chart = true;
          };
        };
      }
    ];
  }
]
