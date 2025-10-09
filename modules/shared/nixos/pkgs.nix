{
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default
    inputs.home-manager.packages."${system}".default

    pciutils
    tcpdump
    lm_sensors
    inetutils
    ncdu
    # liborbispkg-pkgtool
  ];
}
