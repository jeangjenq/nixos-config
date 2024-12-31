{ pkgs, ... }:

{
  home.packages = [ pkgs.joplin-desktop ];
  programs.joplin-desktop = {
    enable = true;
    sync.target = "joplin-server";
    extraConfig = {
      "theme" = 2;
      "clipperServer.autoStart" = true;
    };
  };
}
