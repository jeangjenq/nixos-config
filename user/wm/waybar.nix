{ pkgs, systemSettings, ... }:

let
  workspaces = (systemSettings.wm + "/workspaces");
  window = (systemSettings.wm + "/window");
  mode = if (systemSettings == "hyprland" )
           then "hyprland/submap"
         else "sway/mode";
in
{
  programs.waybar = {
    enable = true;
    settings = {
      modules-left = [
        workspaces
	mode
	window
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "idle_inhibitor"
        "pulseaudio"
	"cpu"
	"memory"
        "battery"
	"backlight"
	"tray"
      ];

      workspaces = {
        "format": "{icon}";
        "format-icons" = {
          "default": "";
	  "active": "";
        };
      };

      window = {
        "icon" = true;
	"separate-outpus" = true;
      };

      clock = {
        "interval"= 30;
	"timezone" = systemSettings.timezone;
        "format": "{:%a, %d %b %Y | %H:%M %p}";
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };

      "pulseaudio" = {
        "format" = "{volume}% {icon} {format_source}",
        "format-bluetooth": "{volume}% {icon} {format_source}",
        "format-bluetooth-muted": " {icon} {format_source}",
        "format-muted": " {format_source}",
        "format-source": "{volume}% ",
        "format-source-muted": "",
        "format-icons": {
          "headphone" = "",
          "hands-free" = "",
          "headset" = "",
          "phone" = "",
          "portable" = "",
          "car" =: "",
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
        "states": {
          "good": 60;
          "warning": 30;
          "critical": 15;
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

      "tray" = {
        "spacing" = 10;
      };

    };
  };
}
