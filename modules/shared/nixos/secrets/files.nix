let
  # files =
  #   builtins.readDir ./.
  #   |> builtins.filter (fileName: builtins.match ".*\\.age" fileName != null)
  #   |> builtins.map (name: name);

  files = builtins.attrNames (builtins.readDir ./.);
  filteredFiles = builtins.filter (fileName: builtins.match ".*\\.age" fileName != null) files;
in
filteredFiles
