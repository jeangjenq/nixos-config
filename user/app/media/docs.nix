{ pkgs, ... }:

{
  home.packages = with pkgs; [
    evince
    foliate
    calibre
  ];

  xdg.mimeApps = {
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
    };
  };
}
