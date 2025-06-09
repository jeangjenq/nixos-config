{ config, pkgs, systemSettings, userSettings, ... }:

{

  imports = [
    ( ./. + "../../../user/wm" + ( "/" + systemSettings.wm + ".nix") )
    (./. + "../../../user/app/terminal" + ("/" + userSettings.term) + ".nix")
    ../../user/app/git/git.nix
    ../../user/shell/sh.nix
    ../../system/hardware/rnnoise.nix
    ../../user/app/browser/firefox.nix
    ../../user/app/browser/thunderbird.nix
    ../../user/app/editor/vscodium.nix
    ../../user/app/media/mpv.nix
    ../../themes/stylix.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  home.stateVersion = "24.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;

  programs.firefox.enable = true;
  home.packages = with pkgs; [
    # core
    adwaita-icon-theme
    nautilus
    gnome-calendar
    seahorse
    speedcrunch
    mission-center
    joplin

    # create
    rapid-photo-downloader
    digikam
    darktable
    hugin
    exiftool

    # media
    yt-dlp
    ffmpeg

    # dev
    remmina
    gparted
    rpi-imager
    isoimagewriter
    veracrypt

    # eww
    teams-for-linux

  ];

  home.sessionVariables = {
  };

  xdg.configFile."mimeapps.list".force = true;
}
