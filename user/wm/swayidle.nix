{ pkgs, lib, systemSettings, ... }:

let
  # DPMS commands differ between window managers
  dpmsCommands = {
    hyprland = {
      off = "hyprctl dispatch dpms off";
      on = "hyprctl dispatch dpms on";
    };
    sway = {
      off = "swaymsg 'output * dpms off'";
      on = "swaymsg 'output * dpms on'";
    };
  };
  dpms = dpmsCommands.${systemSettings.wm} or dpmsCommands.sway;
in
{
  home.packages = with pkgs; [
    swayidle
    swaylock-effects
  ];

  xdg.configFile = {
    "swaylock/config" = {
      text = ''
        screenshots
        clock
        indicator
        indicator-radius=100
        indicator-thickness=7
        effect-blur=7x5
        effect-vignette=0.5:0.5
      '';
    };
    "swayidle/config" = {
      text = ''
        timeout 300 'swaylock -f'
        timeout 360 '${dpms.off}' resume '${dpms.on}'
        before-sleep 'swaylock -f'
      '';
    };
  };

  # Start swayidle for Hyprland (sway handles this via config.startup)
  wayland.windowManager.hyprland.settings = lib.mkIf (systemSettings.wm == "hyprland") {
    exec-once = [ "swayidle -w" ];
  };

  # Start swayidle for sway
  wayland.windowManager.sway.config.startup = lib.mkIf (systemSettings.wm == "sway") [
    { command = "swayidle -w"; }
  ];
}