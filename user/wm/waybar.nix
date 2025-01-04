{ pkgs, systemSettings, ... }:

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
  unfocused = "alpha(shade(@theme_base_color, 1.25), 0.2)";
  focused = "alpha(@theme_selected_fg_color, 0.6)";
  border = "shade(@borders, 1.5)";
  text = "@theme_text_color";
  success = "alpha(@success_color, 0.6)";
  error = "alpha(@error_color, 0.6)";
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        "position" = "top";
        "spacing" = 6;
        modules-left = [
          "clock"
          mode
          window
        ];

        modules-center = [
          workspaces
        ];

        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "cpu"
          "memory"
          "battery"
          "backlight"
          "network"
          "tray"
          "custom/notification"
        ];

        ${workspaces} = {
          "format" = "{icon}";
        };

        ${window} = {
          "icon" = true;
          "icon-size" = 12;
          "separate-outputs"= true;
        };

        "clock" = {
          "interval"= 30;
          "timezone" = systemSettings.timezone;
          "format" = "{:%a, %d %b %Y | %H:%M %p}";
          "tooltip-format" = "<tt><big>{calendar}</big></tt>";
          "on-click" = "gnome-calendar";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };

        "pulseaudio" = {
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
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
          "format" = "cpu: {usage}%";
          "on-click" = "missioncenter";
        };

        "memory" = {
          "interval" = 1;
          "format" = "mem:{}%";
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
          "format" = "{icon} {percent}%";
          "format-icons" = ["🔅" "🔆"];
        };

        "network" = {
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ifname}: {ipaddr}/{cidr} ";
            "format-linked" = "{ifname} (No IP) ";
            "format-disconnected" = "Disconnected ⚠";
        };

        "tray" = {
          "spacing" = 10;
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

      @keyframes blink {
          to {
              background-color: ${error};
              color: ${text};
              font-size: larger;
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
}
