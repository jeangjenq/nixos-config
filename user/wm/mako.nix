{ lib, systemSettings, ... }:

{
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    extraConfig = ''
      [mode=away]
      default-timeout=0
      ignore-timeout=1
    '';
  };

  # Dismiss keybinding for Hyprland
  wayland.windowManager.hyprland.settings = lib.mkIf (systemSettings.wm == "hyprland") {
    bind = [
      "$mainMod, Q, exec, makoctl dismiss"
    ];
  };
}
