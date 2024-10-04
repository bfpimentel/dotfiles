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

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";
    after = [
      "network-pre.target"
      "tailscaled.service"
    ];
    wants = [
      "network-pre.target"
      "tailscaled.service"
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
      ${tailscale}/bin/tailscale up --authkey file:${config.age.secrets.tailscale-servers.path} --advertise-routes=${vars.ip}/32 --accept-dns=true --accept-routes

      # with headscale
      # ${tailscale}/bin/tailscale up --authkey file:${config.age.secrets.tailscale-servers.path} --login-server=https://headscale.bfmp.lol --advertise-routes=${vars.ip}/32 --accept-dns=true
    '';
  };
}
