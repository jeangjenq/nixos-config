{ lib, systemSettings, ... }:

let
  mod = "Mod4";
in
{
  services.swaync = {
    enable = true;
    settings = {
      layer = "overlay";
      timeout = 3;
      timeout-low = 2;
      timeout-critical = 0;
    };
  };

  # Hyprland startup and keybinding
  wayland.windowManager.hyprland.settings = lib.mkIf (systemSettings.wm == "hyprland") {
    exec-once = [ "swaync" ];
    bind = [ "$mainMod, Tab, exec, swaync-client -t -sw" ];
  };

  # Sway startup and keybindings
  wayland.windowManager.sway = lib.mkIf (systemSettings.wm == "sway") {
    config = {
      startup = [
        { command = "swaync"; }
      ];
      keybindings = lib.mkOptionDefault {
        "${mod}+q" = "exec swaync-client -C";      # clear all notifications
        "${mod}+tab" = "exec swaync-client -t -sw";  # toggle notification panel
      };
    };
  };
}
