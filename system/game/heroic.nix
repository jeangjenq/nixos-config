{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    heroic-unwrapped
  ];
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
}
