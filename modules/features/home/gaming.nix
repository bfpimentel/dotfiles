{ ... }:

{
  config.bfmp.hm.hosts.cherubim.modules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          steam
          sunshine
        ];

        systemd.user.services.sunshine = {
          Unit = {
            Description = "Sunshine streaming";
          };

          Service = {
            ExecStart = "${pkgs.sunshine}/bin/sunshine";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      }
    )
  ];
}
