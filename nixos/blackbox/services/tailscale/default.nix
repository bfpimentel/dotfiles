{
  config,
  pkgs,
  vars,
  ...
}:

{
  environment.systemPackages = [ pkgs.tailscale ];

  services.tailscale.enable = true;

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [ 22 ];
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPortRanges = [
      {
        from = 9000;
        to = 9100;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 9000;
        to = 9100;
      }
    ];
  };

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";
    after = [
      "network-pre.target"
      "tailscale.service"
    ];
    wants = [
      "network-pre.target"
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = with pkgs; ''
      # wait tailscale to settle
      sleep 2

      # check if already authenticated
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # authenticate
      ${tailscale}/bin/tailscale up --authkey file:${config.age.secrets.tailscale-blackbox.path} --login-server=https://headscale.bfmp.lol --advertise-routes=${vars.ip}/32 --accept-dns=true
    '';
  };
}
