{ pkgs, userSettings, ... }:

{
  imports = [
    ./wallpapers.nix
  ];

  home.pointerCursor.enable = true;
  services.awww = {
    enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    targets.firefox.profileNames = [
      userSettings.username
    ];
    targets.fcitx5.enable = false;

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
