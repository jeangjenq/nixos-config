{ pkgs, ... }:

{
  stylix.enable = true;
  stylix.image = ./wallpaper/kcdloading01.png;
  stylix.polarity = "dark";

  stylix.targets.waybar.enable = false;

  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
  };

  stylix.fonts.sizes = {
    applications = 10;
    terminal = 12;
    popups = 10;
  };
  
  stylix.opacity = {
    popups = 0.8;
    terminal = 0.85;
  };
}
