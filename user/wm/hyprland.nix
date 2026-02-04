{ pkgs, lib, userSettings, ... }:

{
  imports = [
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./wlogout.nix
    ./swaync.nix
    ./waybar.nix
    ./ime.nix
    ./laptop.nix
  ];

  programs.${userSettings.launcher} = {
    enable = true;
  };

  home.packages = with pkgs; [
    # core
    foot # call this a backup terminal
    hyprpolkitagent # authentication agent
    brightnessctl # control screen brightness
    playerctl # control media playback
    pavucontrol
    networkmanagerapplet

    # screenshot
    grim # take screenshot
    slurp # select screenshot region
    satty # screenshot editor

    # viewers
    nautilus
    gnome-calendar
    imv

  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs [
      # Common raster formats
      "image/jpeg"
      "image/png"
      "image/gif"
      "image/webp"
      "image/bmp"
      "image/tiff"
      "image/x-tiff"

      # Vector formats
      "image/svg+xml"
      "image/svg"

      # Icons
      "image/x-icon"
      "image/vnd.microsoft.icon"

      # Modern formats
      "image/heic"
      "image/heif"
      "image/avif"
      "image/jxl"

      # Editor formats (if imv supports them)
      "image/x-xcf"  # GIMP
      "image/x-psd"  # Photoshop
      "image/x-krita" # Krita
    ] (_: "imv-dir.desktop");
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    settings = let
      terminal = userSettings.term;
      menu = userSettings.launcher;
      mod = "SUPER";
      screenshot = "grim - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png";
      screengrab = "grim -g \"$(slurp)\" - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png";

      # monitors
      primary = userSettings.monitors.primary;
      vertical = userSettings.monitors.vertical;
      lapt = userSettings.monitors.lapt;
    in {
      
      "$mainMod" = mod; # choosing a mod key

      monitor = [
        ("desc:${primary}, maxwidth, 0x0, 1, vrr, 1, cm, auto")# hdr, bitdepth, 10, sdrbrightness, 1.2, sdrsaturation, 1.2")
        ("desc:${vertical}, preferred , 3840x-960 , 1, transform, 1")
        ", preferred, auto, 1, vrr, 1"
      ];

      # something about gamescope now requires scRGB
      debug = {
        full_cm_proto = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      # initial startups
      exec-once = [
        # essentials
        "nm-applet --indicator"
        "blueman-applet"
        "protonmail-bridge --noninteractive"
        "nextcloud"
        "systemctl --user start hyprpolkitagent"

        # preferences
        "[workspace 1] firefox"
        "[workspace 5 silent] MANGOHUD=1 steam"
        "[workspace 6 silent] vesktop"
        "[workspace 7 silent] signal-desktop"
        "[workspace 8 silent] sleep 5 && thunderbird"
      ];

      bind = [
        ("$mainMod, RETURN, exec," + terminal)
        ("$mainMod, D, exec," + menu)
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, SPACE, togglefloating,"
        "$mainMod, F, fullscreen,"
        "$mainMod, E, togglesplit," # dwindle

        # screenshots
        ",print, exec, ${screengrab}"
        "ALT,print, exec, ${screenshot}"
        
        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        
        # Move focus with mainMod + vim keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, J, movefocus, u"
        "$mainMod, K, movefocus, d"
        
        # Move window with mainMod + arrow keys
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        
        # Move window with mainMod + vim keys
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, J, movewindow, u"
        "$mainMod SHIFT, K, movewindow, d"
        
        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        
        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        
        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # media control on specific mkb 
        ",mouse:276, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",mouse:275, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
        ",mouse:278, exec, playerctl play-pause"
        "$mainMod, C, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

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
        enabled = "yes";
        
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.0"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
          "linear, 0.0, 0.0, 1.0, 1.0"
        ];

        animation = [
          "windowsIn, 1, 6, winIn, popin"
          "windowsOut, 1, 5, winOut, popin"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 10, default"
          "borderangle, 1, 100, linear, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
          "windows, 1, 6, wind, slide"
          "specialWorkspace, 1, 6, default, slidefadevert -50%"
        ];
      };
      
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      master = {
        new_status = "master";
      };
      
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        middle_click_paste = false;
	      focus_on_activate = true;
      };
      
      input = {
        kb_layout = "us";
        kb_options = [
          "caps:super"
        ];
        follow_mouse = 1;
        
        numlock_by_default = true;
        accel_profile = "flat";
      };

      cursor = {
        default_monitor = "0";
      };
      
      gesture = [
        "3, horizontal, workspace"
        "3, down, special, magic"
      ];

      layerrule = [
        "match:namespace logout_dialog, blur on"
      ];
      
      # window identifiers
      ## steam
      "$steam" = "match:class ^(steam)$";
      "$steamfloat" = "match:title ^Friends.+|^Steam.+";
      "$steamtoast" = "match:title ^(notificationtoasts_.*_desktop)$";
      "$steam_games" = "match:class ^(steam_app_.*)|^(gamescope)";

      ## popups
      "$filedialog" = "match:class ^(xdg.desktop-portal)";
      # "$filedialog" = "match:title ((Open|Save) (File|Folder|As))";
      "$pavucontrol" = "match:class org.pulseaudio.pavucontrol";
      windowrule = [
        # steam
        "$steam, monitor 0, workspace 5 silent"
        "$steamfloat, monitor 0, workspace 5 silent, float on, opacity 0.85"
        "$steamtoast, no_focus on, pin on, opacity 0.6"

        # games
        "$steam_games, monitor 0, fullscreen on, immediate on, decorate off, no_anim on, idle_inhibit always"

        # comms
        "match:class vesktop, workspace 6, monitor 1"
        "match:class signal, match:title Signal, workspace 7, monitor 1"
        "match:class thunderbird, workspace 8 silent, monitor 1"

        # specific apps
        "match:class tidal-hifi, workspace 9, monitor 1"
        "match:class ^(teams-for-linux)$, workspace 6, monitor 1"
        "match:class ^(pcoip-client)$, workspace 10 silent, monitor 0"

        # popups
        "$filedialog, float on, size 40% 60%, opacity 0.85"
        "$pavucontrol, float on, size 40% 60%, opacity 0.85"
        "match:class ^[tT]hunar, match:title ^(File Operation Progress), float on, opacity 0.85"

        "match:class firefox, match:title (Picture-in-Picture), float on"
        "match:class (^org\.speedcrunch\.$), match:title ^SpeedCrunch$, float on"
        "match:class org\.gnome\.Calculator, float on"
        "match:class org\.gnome\.Calendar, float on"
        "match:class (^com\.gabm\.satty$), float on, fullscreen_state 0 on"
        "match:class ^(com\.nextcloud\.desktopclient\.nextcloud)$, opacity 0.85"

        # specific apps ricing
        "match:class ^(org\.gnome.+)$, opacity 0.85"
        "match:class ^(io\.missioncenter\.MissionCenter)$, opacity 0.85, float on"
        "match:class ^(codium), opacity 0.85"
        "match:class ^(Standard Notes)$, opacity 0.85"
        "match:class ^(@joplin), opacity 0.85"

      ];

      workspace = [
        "r[1-5], monitor:desc:${primary}"
        "r[0], monitor:desc:${primary}"
        "r[6-9], monitor:desc:${vertical}"
        "r[6-9], monitor:${lapt}"
      ];

    };

    extraConfig = ''
      # teradici hotkeys passthrough
      bind = $mainMod SHIFT, Z, submap, passthrough
      submap = passthrough
      bind = $mainMod SHIFT, Z, submap, reset
      submap = reset
    '';
  };

}
