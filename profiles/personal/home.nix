{ config, pkgs, systemSettings, userSettings, ... }:

{

  imports = [
    ../work/home.nix
    ../../user/app/player/music.nix
  ];

  home.packages = with pkgs; [
    # comms
    discord
    signal-desktop

    # players
    tidal-hifi
    strawberry
    jellyfin-media-player
  ];

}
