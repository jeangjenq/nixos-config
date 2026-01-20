{ pkgs, userSettings, ... }:
let
  stylix = import ../../themes/stylix.nix { inherit pkgs userSettings; };
  horizontal = stylix.stylix.image;
  vertical = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/qz/wallhaven-qzxr97.png";
    hash = "sha256-iyX3I46lEllMIHwXE/uuMr3uHJ1J0ZRs0Zs57jCKQUs=";
  };
in
{
  home.packages = with pkgs; [
    hyprpaper
  ];
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "${horizontal}";
        }
        {
          monitor = "${userSettings.monitors.vertical}";
          path = "${vertical}";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [
        "hyprpaper"
      ];
    };
  };
}

