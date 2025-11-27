{ pkgs, userSettings, ... }:

{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/o5/wallhaven-o5w859.png";
      hash = "sha256-Nk+PG4+MhkvgW9CF9Dtj9wH5BgiCilaY0DKRNcHsHwA=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
    polarity = "dark";

    targets.waybar.enable = false;
    targets.firefox.profileNames = [
      userSettings.username
    ];
    targets.fuzzel.enable = true;
    targets.helix.enable = true;

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
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

    fonts.sizes = {
      applications = 10;
      terminal = 12;
      popups = 10;
    };
  
    opacity = {
      popups = 0.8;
      terminal = 0.85;
    };
  };
}
