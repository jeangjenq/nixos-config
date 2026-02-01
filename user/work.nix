{ pkgs, ... }:

{
  home.packages = (with pkgs; [
    teams-for-linux
  ]);

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/msteams" = "teams-for-linux.desktop";
      "x-scheme-handler/pcoip" = "remote-pcoip-client.desktop";
    };
  };

}
