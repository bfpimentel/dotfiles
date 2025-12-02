{
  inputs,
  username,
  hostname,
  specialArgs,
}:

let
  buildHomeManagerConfig =
    hostname:
    let
      absoluteHomeManagerPath = "/etc/nixos/modules/home-manager";
      hostPath = "${absoluteHomeManagerPath}/hosts/${hostname}";
      sharedPath = "${absoluteHomeManagerPath}/shared";
    in
    {
      linkHostApp = config: app: config.lib.file.mkOutOfStoreSymlink "${hostPath}/apps/${app}/config";
      linkSharedApp = config: app: config.lib.file.mkOutOfStoreSymlink "${sharedPath}/apps/${app}/config";
    };
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = specialArgs // {
    homeManagerConfig = buildHomeManagerConfig hostname;
  };
  home-manager.users."${username}" =
    { ... }:
    {
      imports = [
        ./shared
        ./hosts/${hostname}
      ];
    };
}
