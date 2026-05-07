{ lib, systemSettings, ... }:

let
  workstyleExec = "workstyle &> /tmp/workstyle.log";
in
{
  programs.workstyle = {
    enable = true;
    settings = {
      discord = "";
      vesktop = "";
      steam = "";
      Steam = "";
      signal = "";
      mpv = "";
      Gimp = "";
      darktable = "";
      "org.kde.digikam" = "";
      thunderbird = "";
      "org.gnome.Nautilus" = "";
      pavucontrol = "";
      Chromium = "";
      Slack = "";
      cursor = "";
      firefox = "";
      Alacritty = "";
      kitty = "";
      openscad = "";
      obsidian = "";
      feishin = "";
      other = {
        fallback_icon = "";
        deduplicate_icons = true;
        separator = " ";
      };
    };
  };
  xdg.configFile."workstyle/config.toml".force = true;

  # Hyprland startup
  wayland.windowManager.hyprland.settings = lib.mkIf (systemSettings.wm == "hyprland") {
    exec-once = [ workstyleExec ];
  };

  # Sway startup
  wayland.windowManager.sway = lib.mkIf (systemSettings.wm == "sway") {
    config = {
      startup = [
        { command = workstyleExec; }
      ];
    };
  };
}
