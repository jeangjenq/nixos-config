{ pkgs, lib, ... }:

{

  home.packages = [ pkgs.alacritty ];
  programs.alacritty.enable = true;

}
