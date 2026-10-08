{
  pkgs,
  lib,
  systemSettings,
  ...
}:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
      ];
      settings = {
        inputMethod = {
          GroupOrder = {
            "0" = "Default";
          };
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "pinyin";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "pinyin";
        };
        globalOptions = {
          "Hotkey/TriggerKeys" = {
            "0" = "Alt+Shift+Shift_L";
          };
          "Hotkey/AltTriggerKeys" = {
            "0" = "Shift_L";
          };
        };
      };
    };
  };

  # Sway specific startup
  wayland.windowManager.sway.config.startup = lib.mkIf (systemSettings.wm == "sway") [
    { command = "fcitx5 -d -r"; }
  ];

  # Hyprland specific startup and rule
  wayland.windowManager.hyprland = lib.mkIf (systemSettings.wm == "sway") {
    extraLuaFiles = {
      "ime" = {
        content = ''
          hl.on("hyprland.start", function()
            hl.exec_cmd("fcitx5 -d -r")
          end)
        '';
        autoLoad = true;
      };
    };
    settings = {
      window_rule = [
        {
          match.class = "^fcitx$";
          pseudo = true;
        }
      ];
    };
  };
}
