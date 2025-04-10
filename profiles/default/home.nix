{ config, pkgs, systemSettings, userSettings, ... }:

{

  imports = [
    ( ./. + "../../../user/wm" + ( "/" + systemSettings.wm + ".nix") )
    (./. + "../../../user/app/terminal" + ("/" + userSettings.term) + ".nix")
    ../../user/app/git/git.nix
    ../../user/shell/sh.nix
    ../../user/virtualization/virtualization.nix
    ../../user/app/editor/libreoffice.nix
    ../../user/app/editor/vscodium.nix
    ../../user/app/media/mpv.nix
    ../../user/app/editor/joplin.nix
    ../../user/app/browser/firefox.nix
    ../../user/app/browser/thunderbird.nix
    ../../system/hardware/rnnoise.nix
    ../../system/app/obs.nix
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
    nextcloud-client
    protonmail-bridge

    # comms
    # signal-desktop covered by electron wrapper
    vesktop

    # create
    gimp
    krita
    inkscape
    kdenlive
    rapid-photo-downloader
    darktable

    # media
    yt-dlp
    ffmpeg
    strawberry
    jellyfin-media-player

    # dev
    remmina
    gparted
    rpi-imager
    isoimagewriter
    veracrypt
    standardnotes

    # eww
    teams-for-linux
  ];

  home.sessionVariables = {
  };

}
