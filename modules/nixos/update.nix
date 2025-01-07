{
  pkgs,
  username,
  hostname,
  ...
}:

{
  systemd.timers."repo-update" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "repo-update.service";
    };
  };

  systemd.services."repo-update" = {
    wantedBy = [ "nixos-rebuild.service" ];
    requiredBy = [ "nixos-rebuild.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = username;
    };
    script = ''
      eval "$(${pkgs.openssh}/bin/ssh-agent -s)"
      cd /etc/nixos
      ${pkgs.git}/bin/git pull && return -1
    '';
  };

  systemd.services."nixos-rebuild" = {
    after = [ "repo-update.service" ];
    requires = [ "repo-update.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    script = ''
      cd /etc/nixos
      nixos-rebuild switch --flake .#${hostname}@${username}
    '';
  };
}
