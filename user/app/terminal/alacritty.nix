{ pkgs, lib, ... }:

{

  home.packages = [ pkgs.alacritty ];
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.opacity = 0.8;
  };

}
