{
  pkgs,
  lib,
  systemSettings,
  userSettings,
  ...
}:
let
  screenshot = import ./screenshot.nix { inherit pkgs; };
  grab = "${screenshot.grab}/bin/screengrab";
  shot = "${screenshot.shot}/bin/screenshot";
in
{
  imports = [
    ./cliphist.nix
    ./wlogout.nix
    ./swaync.nix
    ./waybar.nix
    ./ime.nix
    ./rofi.nix
  ];

  services.awww = {
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
    imv
  ];

  dconf.settings = {
    "org/blueman/general" = {
      plugin-list = [ "!ConnectionNotifier" ];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      lib.genAttrs [
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
      ] (_: "imv-dir.desktop")
      // {
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
  };

  xdg.desktopEntries = {
    steam-gamescope = {
      name = "Steam (gamescope)";
      comment = "Launch steam in gamescope Big Picture mode";
      categories = [
        "Game"
      ];
      exec = "${userSettings.steamCmd}";
      icon = "steam";
      terminal = false;
      type = "Application";
    };
    steam-remote = {
      name = "Steam (remote play)";
      comment = "Launch steam in smaller res gamescope for streaming to Deck";
      categories = [
        "Game"
      ];
      exec = "${userSettings.steamRemote}";
      icon = "steam";
      terminal = false;
      type = "Application";
    };
  };

  # Screenshot keybindings for Sway
  wayland.windowManager.sway.config.keybindings = lib.mkIf (systemSettings.wm == "sway") ({
    "print" = "exec ${grab}";
    "Alt+print" = "exec ${shot}";
  });

  # Screenshot keybindings for Hyprland
  wayland.windowManager.hyprland.extraLuaFiles = lib.mkIf (systemSettings.wm == "hyprland") {
    "screenshot" = {
      content = ''
        hl.bind("print", hl.dsp.exec_cmd([[${grab}]]))
        hl.bind("ALT + print", hl.dsp.exec_cmd([[${shot}]]))
      '';
      autoLoad = true;
    };
  };
}
