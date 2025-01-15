{ vars, ... }:

{
  programs.git = {
    enable = true;
    userName = vars.defaultUserFullName;
    userEmail = vars.defaultUserEmail;
  };
}
