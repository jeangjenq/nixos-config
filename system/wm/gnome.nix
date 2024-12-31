{ pkgs, ... }:

{
  services.xserver = {
  enable = true;
  displayManager.gdm.enable = true;
  desktopManager.gnome.enable = true;
  excludePackages = [ pkgs.xterm ];
  };

  environment.gnome.excludePackages = ( with pkgs; [
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-tour
    gnome-weather
    gnome-clocks
    cheese # old camera app
    snapshot # new camera app
    totem # video player
    epiphany # gnome web
    geary # gnome email
    yelp # gnome help
    ]
  );

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
  ];
  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  programs.dconf.enable = true;
}
