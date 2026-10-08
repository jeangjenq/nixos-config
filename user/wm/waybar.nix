{
  pkgs,
  lib,
  systemSettings,
  ...
}:

let
  # wm specific changes
  workspaces = (systemSettings.wm + "/workspaces");
  window = (systemSettings.wm + "/window");
  mode = if (systemSettings.wm == "hyprland") then "hyprland/submap" else "sway/mode";
in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = lib.concatLists [
        (lib.optional (systemSettings.wm == "sway") "sway-session.target")
        (lib.optional (systemSettings.wm == "hyprland") "hyprland-session.target")
      ];
    };
    settings = {
      top_bar = {
        "position" = "top";
        "spacing" = 12;
        modules-left = [
          "idle_inhibitor"
          mode
        ];

        modules-center = [
          workspaces
        ];

        modules-right = [
          "tray"
          "custom/notification"
        ];

        ${workspaces} = {
          format = "{icon}";
          icon-size = 14;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };

        "tray" = {
          "spacing" = 8;
        };

        "custom/notification" = {
          "tooltip" = false;
          "format" = "{icon}";
          "format-icons" = {
            "notification" = "<span foreground='red'><sup></sup></span>";
            "none" = "";
            "dnd-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-none" = "";
            "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
        };
      };
      bottom_bar = {
        position = "bottom";
        spacing = 12;
        modules-left = [
          "group/sys"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "mpris"
          "group/control"
        ];

        "group/sys" = {
          orientation = "horizontal";
          modules = [
            "cpu"
            "memory"
            "network"
          ];
        };

        "cpu" = {
          "interval" = 2;
          "format" = " {icon} {usage}%";
          "format-icons" = [
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
          "on-click" = "${pkgs.cosmic-monitor}/bin/cosmic-monitor";
        };

        "memory" = {
          "interval" = 2;
          "format" = " {}%";
          "on-click" = "${pkgs.cosmic-monitor}/bin/cosmic-monitor";
        };

        "network" = {
          format-wifi = "<span color=\"SteelBlue\"></span>";
          tooltip-format-wifi = " {essid} {signalStrength}%";
          format-ethernet = "<span color=\"SteelBlue\"></span>";
          tooltip-format-ethernet = " {ipaddr}/{cidr}";
          format-alt = " {ipaddr}/{cidr}";
          format-linked = "<span color=\"Tomato\"></span>";
          tooltip-format-linked = "{ifname} (No IP)";
          format-disconnected = "<span color=\"Tomato\">⚠</span>";
          tooltip-format-disconnected = "{ifname} (Disconnected)";
        };

        "clock" = {
          "interval" = 30;
          "timezone" = systemSettings.timezone;
          "format" = "{:%a, %d %b %Y | %H:%M}";
          "tooltip-format" = "<tt><big>{calendar}</big></tt>";
          "calendar" = {
            format = {
              today = "<span color=\"tomato\">{}</span>";
            };
          };
        };

        ${window} = {
          "icon" = true;
          "icon-size" = 16;
          "format" = "";
          "separate-outputs" = true;
        };

        "mpd" = {
          "format" =
            "{stateIcon}{consumeIcon}{randomIcon}{repeatIcon}{singleIcon} {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
          "format-disconnected" = "MPD Disconnected";
          "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon} Stopped";
          "interval" = 10;
          "on-click" = "rmpc togglepause";
          "consume-icons" = {
            "on" = " ";
          };
          "random-icons" = {
            "off" = "<span color=\"#f53c3c\"></span> ";
            "on" = " ";
          };
          "repeat-icons" = {
            "on" = " ";
          };
          "single-icons" = {
            "on" = "1 ";
          };
          "state-icons" = {
            "paused" = "";
            "playing" = "";
          };
          "tooltip-format" = "{artist} - {album}";
          "tooltip-format-disconnected" = "MPD (disconnected)";
        };

        "mpris" = {
          format = "<small>{status_icon}</small> {dynamic}";
          title-len = 16;
          interval = 2;
          dynamic-len = 48;
          dynamic-order = [
            "title"
            "artist"
            "position"
            "length"
          ];
          status-icons = {
            "playing" = "<span foreground=\"tomato\"></span>";
            "paused" = "<span foreground=\"tomato\"></span>";
            "stopped" = "<span foreground=\"tomato\"></span>";
          };
        };

        "group/control" = {
          orientation = "horizontal";
          modules = [
            "pulseaudio"
            "backlight"
            "battery"
          ];
        };

        "pulseaudio" = {
          "format" = "{volume}% {icon}   {format_source}";
          "format-bluetooth" = "{volume}% {icon}    {format_source}";
          "format-bluetooth-muted" = " {icon}    {format_source}";
          "format-muted" = "   {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
        };

        "backlight" = {
          "format" = "{percent}% {icon}";
          "format-icons" = [
            "🔅"
            "🔆"
          ];
        };

        "battery" = {
          "states" = {
            "good" = 60;
            "warning" = 40;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
      };
    };

    # stylix override
    style = lib.mkAfter ''
      window#waybar {
          background: alpha(@base00, 0.25);
      }
      tooltip {
          background: alpha(@base00, 0.85);
      }
      #workspaces button {
          background: alpha(@base01, 0.5);
      }
    '';
  };

  # sway comes with a default bar, set to empty when not needed
  wayland.windowManager.sway.config.bars = lib.mkIf (systemSettings.wm == "sway") [ ];
}
