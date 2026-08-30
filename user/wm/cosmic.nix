{ userSettings, ... }:

{
  programs.firefox.profiles.${userSettings.username}.settings = {
    "widget.gtk.libadwaita-colors.enabled" = false;
  };
}
