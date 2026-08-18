{ pkgs, ... }:

{
  wayland.windowManager.sway = {
    package = pkgs.swayfx;
    checkConfig = false;

    extraConfig = ''
      # swayfx
      blur enable
      blur_passes 1
      blur_radius 8
      corner_radius 6
      animation_duration_ms 250
    '';
  };
}
