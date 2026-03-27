{ pkgs, ... }:

{
  systemd.user.services.sunshine = {
    Unit = {
      Description = "Sunshine game streaming host";
      WantedBy = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
