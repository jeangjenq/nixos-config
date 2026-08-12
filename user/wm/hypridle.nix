{ pkgs, ... }:

{
  home.packages = [ pkgs.hypridle ];

  # Hyprland hypridle startup
  wayland.windowManager.hyprland.extraLuaFiles = {
    "idle" = {
      content = ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("hypridle")
        end)
      '';
      autoLoad = true;
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pgrep hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
