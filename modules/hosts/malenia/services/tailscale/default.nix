{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.tailscale;
in
{
  options.bfmp.services.tailscale = {
    enable = mkEnableOption "Enable Tailscale";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ 22 ];
    };

    services.tailscale.enable = true;

    # systemd.services.tailscale-autoconnect = {
    #   description = "Automatic connection to Tailscale";
    #   after = [
    #     "network-pre.target"
    #     "tailscale.service"
    #   ];
    #   wants = [
    #     "network-pre.target"
    #     "tailscale.service"
    #   ];
    #   wantedBy = [ "multi-user.target" ];
    #   serviceConfig.Type = "oneshot";
    #   script = with pkgs; /* bash */ ''
    #     sleep 2
    #     status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
    #
    #     if [ $status = "Running" ]; then
    #       exit 0
    #     fi
    #
    #     ${tailscale}/bin/tailscale up -authkey <your-auth-key>
    #   '';
    # };
  };
}
