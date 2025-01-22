{ pkgs, ... }:
let
  WIDTH="3840";
  HEIGHT="1600";
  DISPLAY="DP-1";
in
{
  hardware = {
    graphics = {
      enable32Bit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    steam
    gamescope
    mangohud
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
    gamescopeSession.args = [
      "--hdr-enabled" "--hdr-itm-enable"
      "--hide-cursor-delay 3000" "--fade-out-duration 200"
      "--xwayland-count 2"
      "--adaptive-sync"
      "-w ${WIDTH}" "-h ${HEIGHT}"
      "-W ${WIDTH}" "-H ${HEIGHT}" "-r 144 -e -O DP-1"
    ];
  };

}
