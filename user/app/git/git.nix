{ config, pkgs, userSettings, ... }:

{
  home.packages = [ pkgs.git ];
  programs.git = {
    enable = true;
    settings = {
      user.name = userSettings.username;
      user.email = userSettings.email;
      init.defaultBranch = "main";
      safe.directory = [ userSettings.dotfilesDir ];
      core.editor = "hx";
      credential.helper = "store";
    };
  };
}
