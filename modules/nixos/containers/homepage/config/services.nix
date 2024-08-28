[
  {
    "Glances" = [
      {
        "Info" = {
          widget = {
            type = "glances";
            url = "http://host.containers.internal:61208";
            metric = "info";
          };
        };
        "CPU Temp" = {
          widget = {
            type = "glances";
            url = "http://host.containers.internal:61208";
            metric = "sensor:Tctl";
          };
        };
        "Storage" = {
          widget = {
            type = "glances";
            url = "http://host.containers.internal:61208";
            metric = "process";
          };
        };
        "Network" = {
          widget = {
            type = "glances";
            url = "http://host.containers.internal:61208";
            metric = "network:enp6s18"; # should be dynamic, depending on host's network interface
            chart = true;
          };
        };
      }
    ];
  }
]
