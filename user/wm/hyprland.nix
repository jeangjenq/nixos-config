{ pkgs, userSettings, ... }:

{
  imports = [
    ../app/terminal/alacritty.nix
    ../app/terminal/kitty.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    # core
    kitty # hyprland default terminal
    mako # notification
    rofi-wayland # app launcher
    hyprpaper # hyprland bg
    hyprpolkitagent # authentication agent
    brightnessctl # control screen brightness
    playerctl # control media playback
    gnome-calculator # like this calculator

    # screenshot
    grim # take screenshot
    slurp # select screenshot region
    satty # screenshot editor

    # tray control
    networkmanagerapplet   
    pavucontrol
  ];
  # services.blueman-applet.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = let
      terminal = userSettings.term;
      fileManager = "nautilus";
      menu = "rofi -show drun -show-icons";
      mod = "SUPER";

      # monitors
      lguw = "DP-1";
      dell = "HDMI-A-1";
      lapt = "eDP-1";
    in {
      
      "$mainMod" = mod; # choosing a mod key

      monitor = [
        (lguw + ", highrr, 0x0, 1, vrr, 1")
        (dell + ", preferred , 3840x-960 , 1, transform, 1")
	(lapt + ", highrr, auto-down, 1.5")
	", preferred, auto, 1"
      ];

      # initial startups
      exec-once = [
        # essentials
        "waybar"
	"hyprpaper"
        "nm-applet --indicator"
        "blueman-applet"
	"systemctl --user start hyprpolkitagent"

	# preferences
	"steam -silent"
	"[workspace 9 silent] thunderbird"
	"[workspace 6 silent] flatpak run com.discordapp.Discord"
	"[workspace 7 silent] signal-desktop"
      ];

      
      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        ("$mainMod, RETURN, exec," + terminal)
        ("$mainMod, R, exec," + menu)
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, SPACE, togglefloating,"
        "$mainMod, F, fullscreen,"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, E, togglesplit," # dwindle
        
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
	middle_click_paste = false;
      };
      
      input = {
        kb_layout = "us";
	kb_options = [
	  "caps:super"
	];
        follow_mouse = 1;
        
        numlock_by_default = true;
        accel_profile = "flat";
        touchpad = {
          natural_scroll = false;
        };
      };
      
      gestures = {
        workspace_swipe = true;
      };
      
      # window identifiers
      ## steam
      "$steamnotifications" = "title:^(notificationtoasts.*)";

      ## popups
      "$filedialog" = "title:((Open|Save) (File|Folder|As))";
      "$pavucontrol" = "class:org.pulseaudio.pavucontrol";
      windowrulev2 = [
        # steam
        "float, class:steam, title:[^(Steam)]"
        "noinitialfocus, class:steam, $steamnotifications"
        "pin, class:steam, $steamnotifications"
        "opacity 0.6, class:steam, $steamnotifications"
        "workspace 5, class:steam"

	# games
	"fullscreen, class:gamescope"
	"fullscreen, class:steam_app_.*"
	"immediate, class:steam_app_.*" # allow tearing for games
	"monitor[0], class:steam_app_.*"

	# comms
        "workspace 6, class:discord"
        "monitor 1 , class:discord"
	"workspace 7, class:signal, title:Signal"
	"monitor 1 , class:signal, title:Signal"
	"workspace 9, class:thunderbird"
	"monitor 1 , class:thunderbird"

	# popups
	"float, $filedialog"
	"size 40% 60%, $filedialog"
	"opacity 0.85, $filedialog"
	
	"float, $pavucontrol"
	"size 40% 60%, $pavucontrol"
	"opacity 0.85, $pavucontrol"
	
	"float, class:firefox, title:(Picture-in-Picture)"
	"float, class:(^org\.speedcrunch\.$), title: ^SpeedCrunch$"
	"float, class:org\.gnome\.Calculator"

	# specific apps ricing
	"opacity 0.85, class:^(org\.gnome\.Nautilus)$"

      ];

      workspace = [
        "r[1-5], monitor:${lguw}"
	"r[0], monitor:${lguw}"
	"r[6-9], monitor:${dell}"
      ];

    };
  };

}
