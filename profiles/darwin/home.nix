{ configs, pkgs, systemSettings, userSettings, ... }:

{
  imports = [
    ( ./. + "../../../user/app/terminal" + ("/" + userSettings.term) + ".nix")
    ../../user/app/git/git.nix
    ../../user/app/media/mpv.nix
    ../../user/app/editor/vscodium.nix
    ../../user/app/browser/firefox.nix
    ../../user/shell/sh.nix
    # ../../themes/stylix.nix
  ];

  programs.firefox.package = null;
  
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # create
    darktable
    yt-dlp
    ffmpeg

    # media
    mpv
  ];
}
