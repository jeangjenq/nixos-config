{
  pkgs,
  userSettings,
  ...
}:

{
  imports = [
    (./. + "../../../user/shell" + ("/" + userSettings.term) + ".nix")
    ../../user/shell/sh.nix
    ../../user/shell/yazi.nix
    ../../user/app/git/git.nix
    ../../user/app/editor/helix.nix
    ../../user/app/browser/firefox.nix
  ];

  programs.firefox.package = null;
  programs.joplin-desktop.package = pkgs.emptyDirectory;

  home.stateVersion = "24.11";
  home.username = userSettings.username;
  home.homeDirectory = "/Users/" + userSettings.username;

  home.packages = with pkgs; [
    # create
    yt-dlp
    ffmpeg
  ];
}
