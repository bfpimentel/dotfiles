{ ... }:

{
  config.bfmp.nixos.sharedModules = [
    (
      { ... }:
      let
        mkContainerWaitMount = automounts: {
          unitConfig = {
            Wants = automounts;
            After = automounts;
          };

          serviceConfig.RestartSec = "60s";
        };
      in
      {
        _module.args.util = {
          inherit mkContainerWaitMount;
        };
      }
    )
  ];
}
