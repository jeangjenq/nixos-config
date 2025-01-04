{ config, pkgs, systemSettings, userSettings, ... }:

{

  imports = [
    ../work/home.nix
    ../../user/app/editor/joplin.nix
    ../../user/app/browser/firefox.nix
  ];

  home.packages = with pkgs; [
    # comms
    # signal-desktop covered by electron wrapper
    vesktop
    thunderbird

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
