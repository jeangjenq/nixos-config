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
  ac = "${pkgs.systemd}/bin/systemd-ac-power";
  brightness_dim = "${ac} || ${pkgs.brightnessctl}/bin/brightnessctl s 30%";
  brightness_restore = "${ac} || ${pkgs.brightnessctl}/bin/brightnessctl -r";
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
        # battery powered
        {
          timeout = 300;
          on-timeout = "${brightness_dim}";
          on-resume = "${brightness_restore}";
        }
        {
          timeout = 600;
          on-timeout = "${ac} || loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "${ac} || ${screen.off}";
          on-resume = "${screen.on}";
        }
        {
          timeout = 1200;
          on-timeout = "${ac} || systemctl suspend";
          on-resume = "${brightness_restore}";
        }
        # ac powered
        {
          timeout = 900;
          on-timeout = "${ac} && loginctl lock-session";
        }
        {
          timeout = 1200;
          on-timeout = "${ac} && ${screen.off}";
          on-resume = "${screen.on}";
        }
        {
          timeout = 1800;
          on-timeout = "${ac} && systemctl suspend";
          on-resume = "${brightness_restore}";
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
        blur_size = 8;
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
