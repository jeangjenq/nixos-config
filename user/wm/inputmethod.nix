{ ... }:

{
  # hyprland specific startup and rule
  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [
        "fcitx5 -d -r"
        "fcitx5-remote -r"
      ];
      windowrule = [
        "pseudo, fcitx"
      ];
    };
  };

  home.file = {
    # make sure stylix is being used as a them
    ".config/fcitx5/conf/classicui.conf" = {
      text = ''
      Theme=FluentDark
      DarkTheme=FluentDark
      UseDarkTheme=True
      '';
      force = true;
    };

    # add pinyin input method right away
    ".config/fcitx5/profile" = {
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
    ".config/fcitx5/config" = {
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
