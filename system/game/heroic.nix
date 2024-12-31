{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    heroic
    gamescope
    mangohud
  ];
}
