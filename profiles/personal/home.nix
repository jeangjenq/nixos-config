{ config, pkgs, systemSettings, userSettings, ... }:

{

  imports = [
    ../work/home.nix
    ../../user/app/editor/joplin.nix
    ../../user/app/browser/firefox.nix
    ../../user/app/browser/thunderbird.nix
  ];

  home.packages = with pkgs; [
    # comms
    # signal-desktop covered by electron wrapper
    vesktop

    # productivity
    nextcloud-client
    protonmail-bridge

    # players
    # tidal-hifi covered by electron wrapper
    strawberry
    jellyfin-media-player

    # photography
    rapid-photo-downloader
    darktable

    # editors
    standardnotes
  ];


}
