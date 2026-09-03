{ pkgs, userSettings, ... }:
let
  terminal = userSettings.term;
  menu = "pkill fuzzel || fuzzel";
  mod = "SUPER";

  # monitors
  primary = userSettings.monitors.primary;
  vertical = userSettings.monitors.vertical;
  lapt = userSettings.monitors.lapt;
in
{
  imports = [
    ./commons.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./laptop.nix
  ];

  home.packages = with pkgs; [
    hyprpolkitagent # authentication agent
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    configType = "lua";

    extraLuaFiles = {
      "nixvars" = {
        content = ''
          return {
            terminal = "${terminal}",
            menu = "${menu}";
            mod = "${mod}";
          }
          '';
        autoLoad = false;
      };
      "keybinds" = {
        content = ./hyprland/keybinds.lua;
        autoLoad = true;
      };
      "submaps" = {
        content = ./hyprland/submaps.lua;
        autoLoad = true;
      };
      "rules" = {
        content = ./hyprland/rules.lua;
        autoLoad = true;
      };
      "startups" = {
        content = ''
          hl.on("hyprland.start", function()
            -- essentials
            hl.exec_cmd("nm-applet --indicator")
            hl.exec_cmd("blueman-applet")
            hl.exec_cmd("protonmail-bridge --noninteractive")
            hl.exec_cmd("nextcloud")
            hl.exec_cmd("systemctl --user start hyprpolkitagent")

            -- preferences
            hl.exec_cmd("[workspace 1] firefox")
            hl.exec_cmd("[workspace 5 silent] gamescope --mangoapp -e -w 3840 -W 3840 -h 1600 -H 1600 -r 120 -f -- steam")
            hl.exec_cmd("[workspace 6 silent] discord")
            hl.exec_cmd("[workspace 7 silent] signal-desktop")
            hl.exec_cmd("[workspace 8 silent] sleep 10 && thunderbird")
            hl.exec_cmd("[workspace 9 silent] feishin")
          end)
        '';
        autoLoad = true;
      };
    };

    settings = {
      monitor = [
        {
          output = "desc:${primary}";
          mode = "preferred";
          position = "0x0";
          scale = 1;
          vrr = 1;
          bitdepth = 10;
          # cm = "hdr";
          # sdrbrightness = 1.4;
          # sdrsaturation = 1.2;
        }
        {
          output = "desc:${vertical}";
          mode = "preferred";
          position = "3840x-960";
          scale = 1;
          transform = 1;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto-down";
          scale = 1;
          vrr = 1;
        }
      ];

      workspace_rule = [
        {
          workspace = "r[0-5]";
          monitor = "desc:${primary}";
        }
        {
          workspace = "r[6-9]";
          monitor = "desc:${vertical}";
        }
        {
          workspace = "r[6-9]";
          monitor = lapt;
        }
      ];

      config = {
        # something about gamescope now requires scRGB
        debug = {
          full_cm_proto = true;
        };

        render = {
          cm_auto_hdr = 1;
        };

        xwayland = {
          force_zero_scaling = true;
        };

        general = {
          gaps_in = 4;
          gaps_out = 12;
          border_size = 1;

          # don't resize window on accidental border click
          resize_on_border = false;

          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 6;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
          blur = {
            enabled = true;
            size = 8;
            passes = 1;
          };
        };

        animations = {
          enabled = true;
        };

        dwindle = {
          force_split = 2;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
          middle_click_paste = false;
          focus_on_activate = true;
        };

        input = {
          kb_layout = "us";
          kb_options = "caps:super";
          follow_mouse = 1;
        
          numlock_by_default = true;
          accel_profile = "flat";

          touchpad = {
            natural_scroll = true;
          };
        };

        cursor = {
          default_monitor = "desc:${primary}";
        };
      };

      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
        {
          fingers = 3;
          direction = "down";
          action = "special";
          workspace_name = "magic";
        }
      ];

      animation = [
        {
          leaf = "global";
          enabled = true;
          speed = 2.5;
          bezier = "default";
        }
      ];
    };
  };
}
