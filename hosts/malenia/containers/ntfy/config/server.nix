vars: {
  base-url = "https://notify.${vars.domain}";
  listen-http = ":80";
  auth-file = "/etc/ntfy/user.db";
  auth-default-access = "deny-all";
  enable-signup = false;
  enable-login = true;
}
