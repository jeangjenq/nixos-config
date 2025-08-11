{ pkgs, ... }:

{
  programs.joplin-desktop = {
    enable = true;
    sync.target = "joplin-server";
    extraConfig = {
      "theme" = 2;
      "clipperServer.autoStart" = true;
    };
  };

  xdg.configFile."joplin-desktop/userstyle.css" = {
    enable = true;
    text = ''
      @media print {
          body {
              font-size: 12px;
          }
      }
    '';
  };
}
