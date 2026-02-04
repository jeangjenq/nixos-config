{ lib, pkgs, systemSettings, ... }:

let
  lockCommands = {
    hyprland = "hyprlock";
    sway = "swaylock -f";
  };
  lockCommand = lockCommands.${systemSettings.wm} or "swaylock -f";
in
{
  home.packages = [
    pkgs.wlogout
  ];

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "lock";
        action = lockCommand;
        text = "Lock";
        keybind = "l";
      }
    ];
  };

  # Sway keybinding for wlogout
  wayland.windowManager.sway.config.keybindings = lib.mkIf (systemSettings.wm == "sway") (lib.mkOptionDefault {
    "Mod4+Shift+e" = "exec wlogout -p layer-shell";
  });

  # Hyprland keybinding for wlogout
  wayland.windowManager.hyprland.settings.bind = lib.mkIf (systemSettings.wm == "hyprland") [
    "SUPER SHIFT, E, exec, wlogout"
  ];
}