{ pkgs, lib, ... }:

{

  home.packages = [ pkgs.alacritty ];
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.opacity = lib.mkForce 0.8;
  };

}
