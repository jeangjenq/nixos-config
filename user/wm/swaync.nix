{ ... }:

{
  services.swaync = {
    enable = true;
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [ "swaync" ];
    bind = [ "$mainMod, A, exec, swaync-client -t -sw" ];
  };
}