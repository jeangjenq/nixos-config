{ config, pkgs, systemSettings, userSettings, ... }:

{

  imports = [
    ( ./. + "../../../user/wm" + ( "/" + systemSettings.wm + ".nix") )
    ../../user/app/git/git.nix
    (./. + "../../../user/app/terminal" + ("/" + userSettings.term) + ".nix")
    ../../user/shell/sh.nix
    ../../user/virtualization/virtualization.nix
    ../../user/app/editor/libreoffice.nix
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

    # create
    gimp
    krita
    inkscape
    obs-studio
    tenacity
    davinci-resolve
    kdenlive

    # media
    mpv
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
  };

}
