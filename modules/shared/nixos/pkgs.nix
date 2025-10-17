{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../pkgs.nix
  ];

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default
    inputs.home-manager.packages."${system}".default

    gcc14

    pciutils
    tcpdump
    lm_sensors
    inetutils
    ncdu
    # liborbispkg-pkgtool
  ];
}
