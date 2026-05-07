{ lib, pkgs, systemSettings, ... }:

let
  # wm specific changes
  workspaces = (systemSettings.wm + "/workspaces");
  window = (systemSettings.wm + "/window");
  mode =  if (systemSettings.wm == "hyprland" )
            then "hyprland/submap"
          else "sway/mode";
  
  # styling
  margin = "12";

  # color
  unfocused = "alpha(shade(@theme_base_color, 1.25), 0.5)";
  focused = "alpha(@theme_selected_fg_color, 0.5)";
  border = "shade(@borders, 1.5)";
  text = "@theme_text_color";
  success = "alpha(@success_color, 0.6)";
  error = "alpha(@error_color, 0.6)";
in
{

  home.packages = [
    pkgs.wf-recorder
    pkgs.slurp
    pkgs.libnotify
    (pkgs.writeShellScriptBin "recorder-toggle" ''
      #!/bin/bash

      pid=`pgrep wf-recorder`
      status=$?
      if [ $status != 0 ]; then
        region=`slurp`
        region_is=$?
        if [ $region_is == 1 ]; then
          notify-send "Region not selected, cancelling recording."
          exit 1
        else
          notify-send "Recording started!" "Your screen is being recorded."
          wf-recorder -yg "$region" -c h264_vaapi -f ~/Videos/$(date +'recording_%Y-%m-%d_%H%M%S.mp4');
        fi
      else
        pkill --signal SIGINT wf-recorder
        notify-send "Recording finished!"
      fi;
    '')
  ];

  programs.waybar = {
    enable = true;
    settings = {
      top_bar = {
        "position" = "top";
        "spacing" = 16;
        modules-left = [
          "custom/record"
          workspaces
          "group/sys"
          mode
        ];

        modules-center = [
          window
          "clock"
          "idle_inhibitor"
        ];

        modules-right = [
          "mpris"
          "group/control"
          "tray"
          "custom/notification"
        ];

        "custom/record" = {
          "format" = "";
          "tooltip" = false;
          "on-click" = "recorder-toggle";
        };

        ${workspaces} = {
          format = "{icon}";
          icon-size = 16;
        };

        ${window} = {
          "icon" = true;
          "icon-size" = 16;
          "format" = "";
          "separate-outputs"= true;
        };

        "group/sys" = {
          orientation = "horizontal";
          modules = [
            "cpu"
            "memory"
            "network"
          ];
        };

        "group/control" = {
          orientation = "horizontal";
          modules = [
            "pulseaudio"
            "backlight"
            "battery"
          ];
        };

        "clock" = {
          "interval"= 30;
          "timezone" = systemSettings.timezone;
          "format" = "{:%H:%M}";
          "format-alt" = "{:%a, %d %b %Y}";
          "tooltip-format" = "<tt><big>{calendar}</big></tt>";
          "calendar" = {
            format = {
              today = "<span color=\"tomato\">{}</span>";
            };
          };
        };

        "mpd" = {
          "format" = "{stateIcon}{consumeIcon}{randomIcon}{repeatIcon}{singleIcon} {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
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

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };

        "pulseaudio" = {
          "format" = "{volume}% {icon}   {format_source}";
          "format-bluetooth" = "{volume}% {icon}    {format_source}";
          "format-bluetooth-muted" = " {icon}    {format_source}";
          "format-muted" = "   {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons"= {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
          "on-click" = "pavucontrol";
        };

        "cpu" = {
          "interval" = 1;
          "format" = "{usage}% ";
          "on-click" = "missioncenter";
        };

        "memory" = {
          "interval" = 1;
          "format" = "{}% ";
          "on-click" = "missioncenter";
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
          "format-icons" = ["" "" "" "" ""];
        };
        
        "backlight" = {
          "format" = "{percent}% {icon}";
          "format-icons" = ["🔅" "🔆"];
        };

        "network" = {
          format-wifi = "<span color=\"SteelBlue\"></span>";
          tooltip-format-wifi = "{essid} {signalStrength}% ";
          format-ethernet = "<span color=\"SteelBlue\"></span>";
          tooltip-format-ethernet = "{ipaddr}/{cidr} ";
          format-alt = "{ipaddr}/{cidr} ";
          format-linked = "<span color=\"Tomato\"></span>";
          tooltip-format-linked = "{ifname} (No IP)";
          format-disconnected = "<span color=\"Tomato\">⚠</span>";
          tooltip-format-disconnected = "{ifname} (Disconnected)";
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
    };

    style = ''
      * {
          padding: 0.1em 0.1em;
          border: none;
          border-radius: 8px;
          font-size: 12px;
      }

      tooltip {
          background: ${unfocused};
          color: ${text};
      }
      
      window#waybar {
          background: transparent;
      }

      .module {
          padding: 0 ${margin}px;
          background-color: ${unfocused};
          box-shadow: inset -0.05em -0.05em ${border};
      }

      .modules-right {
          margin: ${margin}px ${margin}px 0 0;
      }
      .modules-center {
          margin: ${margin}px 0 0 0;
      }
      .modules-left {
          margin: ${margin}px 0 0 ${margin}px;
      }

      #workspaces button {
          padding: 0em 0.25em;
          margin: 0.5em;
      }
      #workspaces button.active {
          background-color: ${success};
          border-color: ${border};
          color: ${text};
      }

      #custom-record {
        color: #FF6347;
      }

      @keyframes blink {
          to {
              background-color: ${error};
              color: ${text};
              /* font-size: larger; */
          }
      }

      #workspaces button.urgent {
          border-radius: 1em;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #battery.warning:not(.charging) {
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #battery.critical:not(.charging) {
          animation-name: blink;
          animation-duration: 0.25s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
    '';
  };

  # Sway bar configuration
  wayland.windowManager.sway.config.bars = lib.mkIf (systemSettings.wm == "sway") [{
    command = "waybar";
  }];

  # Hyprland waybar startup
  wayland.windowManager.hyprland.settings.exec-once = lib.mkIf (systemSettings.wm == "hyprland") [
    "waybar"
  ];
}
