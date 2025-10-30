{ vars, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = vars.defaultUserFullName;
      email = vars.defaultUserEmail;
    };
  };
}
