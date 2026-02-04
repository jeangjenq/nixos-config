{ pkgs, systemSettings, ... }:

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
}