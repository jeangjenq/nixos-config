{ configs, pkgs, systemSettings, userSettings, ... }:

{
  imports = [
    ( ./. + "../../../user/shell" + ("/" + userSettings.term) + ".nix")
    ../../user/app/git/git.nix
    ../../user/app/media/mpv.nix
    ../../user/app/browser/firefox.nix
    ../../user/shell/sh.nix
    ../../user/shell/yazi.nix
    ../../user/shell/helix.nix
  ];

  programs.firefox.package = null;
  programs.joplin-desktop.package = pkgs.emptyDirectory;
  
  home.stateVersion = "24.11";
  home.username = userSettings.username;
  home.homeDirectory = "/Users/" + userSettings.username;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # create
    yt-dlp
    ffmpeg
  ];
}
