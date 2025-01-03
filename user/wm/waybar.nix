{ pkgs, systemSettings, ... }:

let
  workspaces = (systemSettings.wm + "/workspaces");
  window = (systemSettings.wm + "/window");
  mode = if (systemSettings.wm == "hyprland" )
           then "hyprland/submap"
         else "sway/mode";
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
        ];

        ${workspaces} = {
          "format" = "{icon}";
          "format-icons" = {
            "default" = "";
            "active" = "";
	  };
	  "persistent-workspaces" = {
	    "*" = 4;
          };
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
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
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
            "warning" = 30;
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
      };
    };

    style = ''
      * {
	  border: none;
	  border-radius: 6px;
	  padding: 1 3px;
          font-size: 12px;
          font-family: "Roboto Mono Medium";
      }
      
      window#waybar {
          background: transparent;
      }

      .module {
          padding: 0 10px;
          box-shadow: inset 0 -2px rgba(255,255,255,0.4);
      }
      
      .modules-right {
          margin: 10px 10px 0 0;
	  background-color: rgba(255,222,242,0.2);
      }
      .modules-center {
          margin: 10px 0 0 0;
	  background-color: rgba(242,226,255,0.2);
      }
      .modules-left {
          margin: 10px 0 0 10px;
	  background-color: rgba(226,238,255,0.2);
      }

      #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
      
    '';
  };
}
