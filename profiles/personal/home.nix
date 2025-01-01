{ config, pkgs, systemSettings, userSettings, ... }:

{

  imports = [
    ../work/home.nix
    ../../user/app/editor/joplin.nix
    ../../user/app/browser/firefox.nix
  ];

  home.packages = with pkgs; [
    # comms
    discord
    signal-desktop

    # players
    tidal-hifi
    strawberry
    jellyfin-media-player

    # photography
    rapid-photo-downloader
    darktable
  ];

}
