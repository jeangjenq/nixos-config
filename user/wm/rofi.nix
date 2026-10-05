{
  config,
  pkgs,
  lib,
  systemSettings,
  ...
}:
let
  launcher = "pkill rofi || rofi -show drun";
  dmenu = "rofi -dmenu";
in
{
  imports = [
    (import ./dmenu.nix {
      inherit
        pkgs
        lib
        systemSettings
        dmenu
        ;
    })
  ];

  # window managers and their hotkeys
  wayland.windowManager.sway.config.keybindings = lib.mkIf (systemSettings.wm == "sway") {
    "Mod4+d" = "exec ${launcher}";
  };
  wayland.windowManager.hyprland.extraLuaFiles = lib.mkIf (systemSettings.wm == "hyprland") {
    "launcher" = {
      content = ''
        hl.bind("SUPER + D", hl.dsp.exec_cmd(${launcher}))
      '';
      autoLoad = true;
    };
  };

  # rofi config
  programs.rofi = {
    enable = true;
    settings = {
      modes = [
        "drun"
      ];
      display-drun = "Applications:";
      show-icons = true;
      matching = "fuzzy";
      font = "${config.stylix.fonts.monospace.name} 12";
    };
  };
}
