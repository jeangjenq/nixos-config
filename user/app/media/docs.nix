{ pkgs, ... }:

{
  home.packages = with pkgs; [
    evince
    foliate
  ];

  xdg.mimeApps = {
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
    };
  };
}