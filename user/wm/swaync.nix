{ ... }:

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

  wayland.windowManager.hyprland.settings = {
    exec-once = [ "swaync" ];
    bind = [ "$mainMod, A, exec, swaync-client -t -sw" ];
  };
}