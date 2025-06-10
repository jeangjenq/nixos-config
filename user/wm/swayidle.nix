{ pkgs, ... }:

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
      timeout 360 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
      before-sleep 'swaylock -f' 
      '';
    };
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [ "swayidle -w" ];
  };
}