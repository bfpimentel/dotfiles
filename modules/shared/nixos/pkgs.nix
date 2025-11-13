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
    inputs.agenix.packages."${stdenv.hostPlatform.system}".default
    inputs.home-manager.packages."${stdenv.hostPlatform.system}".default

    gcc14

    pciutils
    tcpdump
    lm_sensors
    inetutils
    ncdu
    # liborbispkg-pkgtool
  ];
}
