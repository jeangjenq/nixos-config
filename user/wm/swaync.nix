{ lib, systemSettings, ... }:

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
      keybindings = {
        "Mod4+q" = "exec swaync-client -C"; # clear all notifications
        "Mod4+tab" = "exec swaync-client -t -sw"; # toggle notification panel
      };
    };
  };
}
