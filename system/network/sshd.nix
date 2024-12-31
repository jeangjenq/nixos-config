{ userSettings, authorizedKeys? [], ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.${userSettings.username}.openssh.authorizedKeys.keys = authorizedKeys;
}
