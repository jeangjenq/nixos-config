{
  pkgs,
  lib,
  ...
}:
let
  start = [
    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
  ];
  sway-start = map (s: { command = s; }) start;
  hypr-start = lib.concatLines (map (s: ''hl.exec_cmd("${s}")'') start);

  rofi-theme = lib.concatStringsSep " " [
    "window { width: 1200px; height: 800px; }"
    "element-icon { size: 64px; border-radius: 8px; padding: 2px; }"
    "element-text { vertical-align: 0.5; }"
  ];
  call = lib.concatStringsSep " " [
    "${pkgs.rofi}/bin/rofi"
    "-modi clipboard:cliphist-rofi-img"
    "-show clipboard"
    "-show-icons"
    "-theme-str '${rofi-theme}'"
  ];
in
{
  home.packages = [
    pkgs.cliphist
    pkgs.wl-clipboard
  ];

  wayland.windowManager = {
    sway.config = {
      startup = sway-start;
      keybindings = {
        "Mod4+Shift+v" = "exec ${call}";
      };
    };
    hyprland.extraLuaFiles."cliphist" = {
      content = ''
        hl.on("hyprland.start", function()
          ${hypr-start}
        end)
        hl.bind(
          "SUPER+SHIFT+v",
          hl.dsp.exec_cmd("${call}")
        )
      '';
      autoLoad = true;
    };
  };
}
