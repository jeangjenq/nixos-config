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
      "startups" = {
        content = ./hyprland/startups.lua;
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
          enabled = false;
        };
        #   bezier = [
        #     "wind, 0.05, 0.9, 0.1, 1.05"
        #     "winIn, 0.1, 1.1, 0.1, 1.0"
        #     "winOut, 0.3, -0.3, 0, 1"
        #     "liner, 1, 1, 1, 1"
        #     "linear, 0.0, 0.0, 1.0, 1.0"
        #   ];

        #   animation = [
        #     "windowsIn, 1, 6, winIn, popin"
        #     "windowsOut, 1, 5, winOut, popin"
        #     "windowsMove, 1, 5, wind, slide"
        #     "border, 1, 10, default"
        #     "borderangle, 1, 100, linear, loop"
        #     "fade, 1, 10, default"
        #     "workspaces, 1, 5, wind"
        #     "windows, 1, 6, wind, slide"
        #     "specialWorkspace, 1, 6, default, slidefadevert -50%"
        #   ];

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

      layer_rule = [
        {
          match = { namespace = "logout_dialog"; };
          blur = true;
        }
      ];

      window_rule = [
        {
          match.class = "^steam$";
          monitor = 0;
          workspace = "5 silent";
        }
        {
          match = {
            class = "^steam$";
            title = "negative:^Steam$";
          };
          monitor = 0;
          workspace = "5 silent";
          float = true;
          opacity = 0.9;
        }
        {
          match = {
            class = "^steam$";
            title = "^(notificationtoasts_.*_desktop)$";
          };
          no_focus = true;
          # pin = true;
          opacity = 0.6;
        }
        {
          match.class = "^(steam_app_.*)|^(gamescope)";
          monitor = 0;
          fullscreen = true;
          immediate = true;
          decorate = false;
          no_anim = true;
          idle_inhibit = "always";
          render_unfocused = true;
        }

        {
          match.class = "^(xdg.desktop-portal)";
          float = true;
          opacity = 0.85;
        }
        {
          match.title = "^(Open|Save) (File|Folder|As).+";
          float = true;
          opacity = 0.85;
        }
        {
          match.class = "org.pulseaudio.pavucontrol";
          float = true;
          opacity = 0.85;
        }
        {
          match = {
            class = "^[tT]hunar";
            title = "^(File Operation Progress)";
          };
          float = true;
          opacity = 0.85;
        }

        {
          match.class = "vesktop|discord";
          monitor = 1;
          workspace = "6 silent";
        }
        {
          match = {
            class = "signal";
            title = "Signal";
          };
          monitor = 1;
          workspace = "7 silent";
        }
        {
          match.class = "thunderbird";
          monitor = 1;
          workspace = "8 silent";
        }

        {
          match = {
            class = "firefox";
            title = "Picture-in-Picture";
          };
          float = true;
        }
        {
          match = {
            class = "^org\.speedcrunch\.$";
            title = "^SpeedCrunch$";
          };
          float = true;
        }
        {
          match.class = "^org\.gnome\.Cal.+";
          float = true;
        }
        {
          match.class = "^(com\.nextcloud}.desktopclient\.nextcloud)$";
          opacity = 0.85;
          stay_focused = true;
        }
        {
          match.class = "^(io\.missioncenter\.MissionCenter)$";
          float = true;
          opacity = 0.85;
        }

        {
          match.class = "^org\.gnome\..+";
          opacity = 0.85;
        }
        {
          match.class = "(tidal-hifi)|(feishin)";
          monitor = 1;
          workspace = 9;
          opacity = 0.95;
        }
        {
          match.class = "^(teams-for-linux)$";
          monitor = 1;
          workspace = 6;
        }
        {
          match.class = "^(pcoip-client)$";
          monitor = 0;
          workspace = "10 silent";
        }
      ];
    };
  };
}
