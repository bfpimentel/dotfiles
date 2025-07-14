{ vars, ... }:

let
  username = vars.defaultUser;

  mkSecret = filePath: {
    file = filePath;
    mode = "600";
    owner = vars.defaultUser;
    group = vars.defaultUser;
  };

  files = import ./secrets/files.nix;
in
{
  age = {
    identityPaths = [ "/home/${username}/.ssh/id_personal" ];

    secrets = builtins.listToAttrs (
      builtins.map (fileName: {
        name =
          let
            strLen = builtins.stringLength fileName;
            secretName = builtins.substring 0 (strLen - 4) fileName;
          in
          secretName;
        value = mkSecret ../../secrets/${fileName};
      }) files
    );
  };
}
