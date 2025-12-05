{ pkgs, pkgs-stable, systemSettings, userSettings, ... }:

{

  imports = [
    ( ./. + "../../../user/wm" + ( "/" + systemSettings.wm + ".nix") )
    (./. + "../../../user/shell" + ("/" + userSettings.term) + ".nix")
    ../../user/app/git/git.nix
    ../../user/shell/sh.nix
    ../../user/shell/yazi.nix
    ../../user/shell/helix.nix
    ../../user/virtualization/virtualization.nix
    ../../user/app/editor/libreoffice.nix
    ../../user/app/editor/vscodium.nix
    ../../user/app/media/mpv.nix
    ../../user/app/media/mpd.nix
    ../../user/app/media/rmpc.nix
    ../../user/app/media/docs.nix
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
  
  home.packages = (with pkgs; [
    # core
    adwaita-icon-theme
    speedcrunch
    mission-center
    nextcloud-client
    protonmail-bridge
    scrcpy

    # comms
    # signal-desktop covered by electron wrapper
    vesktop
    newsflash

    # create
    gimp
    kdePackages.kdenlive
    digikam
    darktable
    siril
    hugin
    exiftool

    # media
    yt-dlp
    tidal-dl
    ffmpeg

    # dev
    remmina
    isoimagewriter
    veracrypt
    obsidian

    # eww
    teams-for-linux
  ])
  ++
  (with pkgs-stable ;[
  ]);

  home.sessionVariables = {
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/msteams" = "teams-for-linux.desktop";
      "x-scheme-handler/discord" = "vesktop.desktop";
      "x-scheme-handler/pcoip" = "remote-pcoip-client.desktop";
    };
  };
  xdg.configFile."mimeapps.list".force = true;

}
