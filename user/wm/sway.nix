{ pkgs, lib, userSettings, ... }:

{
  imports = [
    ./commons.nix
    ./swaylock.nix
    ./swayidle.nix
  ];

  home.packages = with pkgs; [
    polkit_gnome # authentication agent
    swayest-workstyle
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;

    config = let
      terminal = userSettings.term;
      menu = userSettings.launcher;
      mod = "Mod4";

      # window rule presets
      gameRule = "inhibit_idle focus; floating enable; border none; fullscreen enable; shadows disable";
      popupRule = "floating enable; border pixel 1; sticky enable; shadows enable";
      floatRule = "floating enable; border pixel 1; shadows enable";
      videoRule = "inhibit_idle fullscreen; border none; max_render_time off";
    in {
      modifier = mod;
      terminal = terminal;
      menu = menu;

      # Style
      defaultWorkspace = "workspace number 1";
      gaps = {
        inner = 2;
        outer = 2;
      };
      window = {
        border = 1;
        titlebar = false;
        commands = [
          # floating windows
          { criteria = { title = "(Friends List)|(Steam Settings)"; class = "steam"; }; command = floatRule; }
          { criteria = { app_id = "galculator"; }; command = floatRule; }
          { criteria = { app_id = "onboard.?+"; }; command = floatRule; }
          { criteria = { app_id = "org.pulseaudio.pavucontrol"; }; command = popupRule; }
          { criteria = { app_id = "org.gnome.Calculator"; }; command = floatRule; }
          { criteria = { app_id = "org.gnome.Calendar"; }; command = floatRule; }
          { criteria = { app_id = "xdg-desktop-portal.*"; }; command = floatRule; }
          { criteria = { app_id = "org.speedcrunch."; }; command = floatRule; }
          { criteria = { app_id = "com.gabm.satty"; }; command = floatRule; }
          { criteria = { app_id = "io.missioncenter.MissionCenter"; }; command = floatRule; }
          { criteria = { app_id = "thunar"; title = "File Operation Progress"; }; command = floatRule; }
          { criteria = { app_id = "Thunar"; title = "File Operation Progress"; }; command = floatRule; }
          { criteria = { app_id = "com.nextcloud.desktopclient.nextcloud"; }; command = floatRule; }

          # steam toast notifications
          { criteria = { title = "^notificationtoasts_.*_desktop$"; class = "steam"; }; command = "no_focus; floating enable; sticky enable"; }

          # games
          { criteria = { instance = "gamescope"; }; command = gameRule; }
          { criteria = { class = "gamescope"; }; command = gameRule; }
          { criteria = { app_id = "gamescope"; }; command = gameRule; }
          { criteria = { class = "steam_app.*"; }; command = gameRule; }
          { criteria = { instance = "steam_app.*"; }; command = gameRule; }
          { criteria = { app_id = "steamlink"; }; command = gameRule; }
          { criteria = { class = "Stardew*"; }; command = gameRule; }
          { criteria = { class = "Celeste*"; }; command = gameRule; }
          { criteria = { instance = "Godot_Engine"; }; command = gameRule; }

          # popups
          { criteria = { app_id = "firefox"; title = "^Picture-in-Picture$"; }; command = popupRule; }
          { criteria = { title = "(?:Open|Save) (?:File|Folder|As)"; app_id = "dolphin|org.kde.ark|pcmanfm|pcmanfm-qt"; }; command = popupRule; }
          { criteria = { title = "^(File|Folder)\\s*Already Exists\\s*—\\s*"; app_id = "dolphin|org.kde.ark|pcmanfm|pcmanfm-qt"; }; command = popupRule; }
          { criteria = { title = "Confirm to replace files"; app_id = "dolphin|org.kde.ark|pcmanfm|pcmanfm-qt"; }; command = popupRule; }

          # video
          { criteria = { app_id = "mpv"; }; command = videoRule; }
          { criteria = { app_id = ".+jellyfin.+"; }; command = videoRule; }
          { criteria = { instance = "SpaceCrew.*"; }; command = videoRule; }
        ];
      };

      # Input configuration
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_options = "caps:super";
        };
        "type:pointer" = {
          accel_profile = "flat";
        };
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };
      };

      # Workspace assignments
      assigns = {
        "1" = [{ app_id = "firefox"; }];
        "5" = [
          { title = "^Steam$"; class = "steam"; }
          { title = "^Friends List"; class = "steam"; }
          { title = "^Sign in to Steam"; class = "steam"; }
          { title = "^Special Offers"; class = "steam"; }
        ];
        "6" = [
          { class = "teams-for-linux"; }
          { app_id = "teams-for-linux"; }
          { class = "discord"; }
          { app_id = "com.discordapp.Discord"; }
          { class = "vesktop"; }
          { app_id = "vesktop"; }
        ];
        "7" = [
          { class = "Signal"; }
          { app_id = "signal"; }
        ];
        "8" = [{ app_id = "thunderbird"; }];
        "9" = [
          { class = "tidal-hifi"; }
          { app_id = "tidal-hifi"; }
        ];
        "10" = [
          { class = "pcoip-client"; }
          { app_id = "pcoip-client"; }
        ];
      };

      # Keybindings
      keybindings = lib.mkOptionDefault {
        # Basics
        "${mod}+Return" = "exec ${terminal}";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec ${menu}";
        "${mod}+Shift+c" = "reload";

        # Focus movement with vim keys
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Focus movement with arrow keys
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        # Move windows with vim keys
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # Move windows with arrow keys
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        # Workspaces
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        # Move to workspaces
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        # Layout
        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+f" = "fullscreen";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        # Scratchpad
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";

        # Modes
        "${mod}+r" = "mode resize";
        "${mod}+Shift+z" = ''mode "No hotkeys: mod+Shift+z to exit"'';

        # Media controls (--locked equivalent handled via extraConfig)
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.2";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.2";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_SOURCE@ toggle";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        "${mod}+c" = "exec wpctl set-mute @DEFAULT_SOURCE@ toggle";

        # Brightness
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
      };

      # Modes
      modes = {
        resize = {
          "h" = "resize shrink width 10px";
          "j" = "resize grow height 10px";
          "k" = "resize shrink height 10px";
          "l" = "resize grow width 10px";
          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";
          "Return" = "mode default";
          "Escape" = "mode default";
        };
        "No hotkeys: mod+Shift+z to exit" = {
          "${mod}+Shift+z" = "mode default";
        };
      };

      # Startup applications (matching Hyprland)
      startup = [
        # Essentials
        { command = "nm-applet --indicator"; }
        { command = "blueman-applet"; }
        { command = "protonmail-bridge --noninteractive"; }
        { command = "nextcloud"; }
        { command = "sworkstyle &> /tmp/sworkstyle.log"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }

        # Applications
        { command = "firefox"; }
        { command = "MANGOHUD=1 steam"; }
        { command = "vesktop"; }
        { command = "signal-desktop"; }
        { command = "sleep 5 && thunderbird"; }
      ];

      floating = {
        modifier = mod;
        criteria = [
          { app_id = "galculator"; }
          { app_id = "pavucontrol"; }
          { app_id = "org.gnome.Calculator"; }
          { app_id = "org.gnome.Calendar"; }
          { app_id = "firefox"; title = "^Picture-in-Picture$"; }
          { app_id = "xdg-desktop-portal.*"; }
          { app_id = "org.speedcrunch."; }
          { app_id = "com.gabm.satty"; }
          { app_id = "io.missioncenter.MissionCenter"; }
        ];
      };
    };

    extraConfig = ''
      # Include system sway config (required for dbus)
      include /etc/sway/config.d/*

      # Disable shortcut inhibitor globally
      seat * shortcuts_inhibitor disable

      # Gestures
      bindgesture {
        swipe:3:right workspace prev
        swipe:3:left workspace next
        pinch:inward+up move up
        pinch:inward+down move down
        pinch:inward+left move left
        pinch:inward+right move right
      }

      # Device-specific mouse bindings
      set $huge "1390:284:Getech_HUGE_TrackBall"
      set $logi "1133:16517:Logitech_G604"
      set $exg  "1390:297:ELECOM_TrackBall_Mouse_EX-G_Pro_TrackBall"

      bindsym --input-device=$huge --whole-window BTN_EXTRA exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.2
      bindsym --input-device=$huge --whole-window BTN_SIDE  exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.2
      bindsym --input-device=$huge --whole-window BTN_BACK  exec playerctl play-pause
      bindsym --input-device=$exg --whole-window BTN_EXTRA exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.2
      bindsym --input-device=$exg --whole-window BTN_SIDE  exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.2
      bindsym --input-device=$exg --whole-window BTN_FORWARD  exec playerctl play-pause
      bindsym --input-device=$logi --whole-window BTN_EXTRA exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.2
      bindsym --input-device=$logi --whole-window BTN_SIDE exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.2

      # Clamshell mode (laptop lid handling)
      set $laptop "eDP-1"
      bindswitch --reload --locked lid:on output $laptop disable
      bindswitch --reload --locked lid:off output $laptop enable
    '';
  };
}
