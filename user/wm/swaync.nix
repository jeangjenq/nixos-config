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
  wayland.windowManager.hyprland = lib.mkIf (systemSettings.wm == "hyprland") {
    extraLuaFiles = {
      "swaync" = {
        content = ''
          hl.on("hyprland.start", function()
            hl.exec_cmd("swaync")
          end)
          hl.bind(
            "SUPER + Tab",
            hl.dsp.exec_cmd("swaync-client -t -sw")
          )
        '';
        autoLoad = true;
      };
    };
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
