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
        after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({action=\"enable\"})'";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({action=\"disable\"})'";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({action=\"enable\"})'";
        }
      ];
    };
  };
}
