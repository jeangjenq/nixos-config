{ pkgs, lib, userSettings, systemSettings, ... }:

let
  screenshot = "grim - | satty --filename - --fullscreen --output-filename ~/Pictures/satty-$(date '+%Y%m%d-%H:%M:%S').png";
  screengrab = "grim -g \"$(slurp)\" - | satty --filename - --fullscreen --output-filename ~/Pictures/satty-$(date '+%Y%m%d-%H:%M:%S').png";
in
{
  imports = [
    ./wlogout.nix
    ./swaync.nix
    ./waybar.nix
    ./workstyle.nix
    ./ime.nix
  ];

  programs.${userSettings.launcher} = {
    enable = true;
  };

  home.packages = with pkgs; [
    # core
    foot # backup terminal
    brightnessctl # control screen brightness
    playerctl # control media playback
    pavucontrol
    networkmanagerapplet

    # screenshot
    grim # take screenshot
    slurp # select screenshot region
    satty # screenshot editor

    # viewers
    nautilus
    gnome-calendar
    imv
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs [
      # Common raster formats
      "image/jpeg"
      "image/png"
      "image/gif"
      "image/webp"
      "image/bmp"
      "image/tiff"
      "image/x-tiff"

      # Vector formats
      "image/svg+xml"
      "image/svg"

      # Icons
      "image/x-icon"
      "image/vnd.microsoft.icon"

      # Modern formats
      "image/heic"
      "image/heif"
      "image/avif"
      "image/jxl"

      # Editor formats
      "image/x-xcf"
      "image/x-psd"
      "image/x-krita"
    ] (_: "imv-dir.desktop");
  };

  # Screenshot keybindings for Sway
  wayland.windowManager.sway.config.keybindings = lib.mkIf (systemSettings.wm == "sway") (lib.mkOptionDefault {
    "print" = "exec ${screengrab}";
    "Alt+print" = "exec ${screenshot}";
  });

  # Screenshot keybindings for Hyprland
  wayland.windowManager.hyprland.settings.bind = lib.mkIf (systemSettings.wm == "hyprland") [
    ",print, exec, ${screengrab}"
    "ALT,print, exec, ${screenshot}"
  ];
}
