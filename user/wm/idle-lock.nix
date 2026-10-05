{
  pkgs,
  systemSettings,
  ...
}:
let
  # DPMS commands differ between window managers
  dpms = {
    hyprland = {
      off = "${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.dpms({action=\"disable\"})'";
      on = "${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.dpms({action=\"enable\"})'";
    };
    sway = {
      off = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
      on = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
    };
  };
  screen = dpms.${systemSettings.wm};
  lock = "pgrep hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
  font = "Terminess Nerd Font";
in

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = lock;
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = screen.on;
      };

      listener = [
        {
          timeout = 595;
          on-timeout = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = screen.off;
          on-resume = screen.on;
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        path = "screenshot";
        blur_passes = 2;
        blur_size = 4;
      };
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      label = [
        {
          # weather
          text = "cmd[update:900000] ${pkgs.curl}/bin/curl --silent --connect-timeout 3 --max-time 3 'wttr.in/?format=3'";
          position = "0, -25%";
          font_family = font;
          font_size = 12;
          halign = "center";
          valign = "top";
        }
        {
          # time
          text = "$TIME";
          position = "0, 50";
          font_family = font;
          font_size = 128;
          halign = "center";
          valign = "center";
        }
        {
          # date
          text = "cmd[update:60000] echo -e \"$(${pkgs.coreutils}/bin/date +\"%A %d %b %Y\")\"";
          position = "0, -100";
          font_family = font;
          font_size = 16;
          halign = "center";
          valign = "center";
        }
      ];

      input-field = {
        size = "100, 100";
        position = "0, -25%";
        hide_input = true;
        placeholder_text = "<i>password...</i>";
      };
    };
  };
}
