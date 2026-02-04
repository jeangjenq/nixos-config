{ lib, systemSettings, ... }:

{
  # Hyprland specific startup and rule
  wayland.windowManager.hyprland.settings = lib.mkIf (systemSettings.wm == "hyprland") {
    exec-once = [
      "fcitx5 -d -r"
      "fcitx5-remote -r"
    ];
    windowrule = [
      "match:class ^fcitx$, pseudo on"
    ];
  };

  # Sway specific startup
  wayland.windowManager.sway.config.startup = lib.mkIf (systemSettings.wm == "sway") [
    { command = "fcitx5 -d -r"; }
  ];

  xdg.configFile = {
    # make sure stylix is being used as a them
    "fcitx5/conf/classicui.conf" = {
      text = ''
      Theme=FluentDark
      DarkTheme=FluentDark
      UseDarkTheme=True
      '';
      force = true;
    };

    # add pinyin input method right away
    "fcitx5/profile" = {
      text = ''
      [Groups/0]
      # Group Name
      Name=Default
      # Layout
      Default Layout=us
      # Default Input Method
      DefaultIM=pinyin
      
      [Groups/0/Items/0]
      # Name
      Name=keyboard-us
      # Layout
      Layout=
      
      [Groups/0/Items/1]
      # Name
      Name=pinyin
      # Layout
      Layout=
      
      [GroupOrder]
      0=Default
      '';
      force = true; # this file keeps getting replaced
    };

    # change to preferred hotkey
    "fcitx5/config" = {
      text = ''
      [Hotkey/TriggerKeys]
      0=Alt+Shift+Shift_L
      
      [Hotkey/AltTriggerKeys]
      0=Shift_L
      '';
      force = true;
    };
  };
}
