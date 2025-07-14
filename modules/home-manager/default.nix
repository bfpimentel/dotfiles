{
  username,
  hostname,
  specialArgs,
}:

let
  buildHomeManagerConfig =
    hostname:
    let
      absoluteRootPath = "/etc/nixos/modules/home-manager";
      hostPath = "${absoluteRootPath}/hosts/${hostname}";
      sharedPath = "${absoluteRootPath}/shared";
    in
    {
      linkHostApp = config: app: config.lib.file.mkOutOfStoreSymlink "${hostPath}/${app}/config";
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
