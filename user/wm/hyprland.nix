{ pkgs, userSettings, ... }:

{
  imports = [
    ../app/terminal/alacritty.nix
    ../app/terminal/kitty.nix
  ];

  home.packages = with pkgs; [
    # core
    kitty # hyprland default terminal
    mako # notification
    rofi-wayland # app launcher
    hyprpaper # hyprland bg
    waybar # statusbar
    hyprpolkitagent # authentication agent
    brightnessctl # control screen brightness
    playerctl # control media playback

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
    in {
      
      "$mainMod" = mod; # choosing a mod key

      monitor = [
        "DP-1, highrr, 0x0, 1, vrr, 1"
        "HDMI-A-1, preferred , 3840x-960 , 1, transform, 1"
	"eDP-1, highrr, auto-down, 1.5"
	", preferred, auto, 1"
      ];

      # initial startups
      exec-once = [
        "waybar"
        "nm-applet --indicator"
        "blueman-applet"
	"systemctl --user start hyprpolkitagent"
      ];

      
      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        ("$mainMod, Q, exec," + terminal)
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        ("$mainMod, E, exec," + fileManager)
        "$mainMod, V, togglefloating,"
        ("$mainMod, R, exec," + menu)
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle
        
        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        
        # Move focus with mainMod + vim keys
	"$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, j, movefocus, u"
        "$mainMod, k, movefocus, d"
        
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
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        
        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        
        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        
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
        gaps_in = 2;
	gaps_out = 4;
	border_size = 1;

	# don't resize window on accidental border click
	resize_on_border = false;

	allow_tearing = false;
	layout = "dwindle";
      };

      decoration = {
        rounding = 4;
	shadow = {
	  enabled = true;
	  range = 4;
	  render_power = 3;
	};
	blur = {
	  enabled = true;
	  size = 3;
	  passes = 1;
	};
      };

      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = [
	  "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
	  "global, 1, 10, default"
          "global,border, 1, 5.39, easeOutQuint"
          "global,windows, 1, 4.79, easeOutQuint"
          "global,windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "global,windowsOut, 1, 1.49, linear, popin 87%"
          "global,fadeIn, 1, 1.73, almostLinear"
          "global,fadeOut, 1, 1.46, almostLinear"
          "global,fade, 1, 3.03, quick"
          "global,layers, 1, 3.81, easeOutQuint"
          "global,layersIn, 1, 4, easeOutQuint, fade"
          "global,layersOut, 1, 1.5, linear, fade"
          "global,fadeLayersIn, 1, 1.79, almostLinear"
          "global,fadeLayersOut, 1, 1.39, almostLinear"
          "global,workspaces, 1, 1.94, almostLinear, fade"
          "global,workspacesIn, 1, 1.21, almostLinear, fade"
          "global,workspacesOut, 1, 1.94, almostLinear, fade"
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
      };
      
      input = {
        kb_layout = "us";
	kb_options = [
	  "capslock:super"
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

    };
  };
}
