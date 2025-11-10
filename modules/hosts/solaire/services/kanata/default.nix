{
  config,
  vars,
  ...
}:

let
  kanataPath = "~/.config/kanata";
in
{
  launchd.daemons.kanata = {
    command = "kanata -c ${kanataPath}/personal.kbd";
    serviceConfig = {
      Label = "org.nixos.kanata";
      UserName = "root";
      GroupName = "root";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/Library/Logs/Kanata/kanata.out.log";
      StandardErrorPath = "/Library/Logs/Kanata/kanata.err.log";
    };
  };
}
