{
  pkgs,
  lib,
  dmenu,
  systemSettings,
  ...
}:
let
  # this is gonna be hard to read so we inheriting the base function
  inherit (lib) filter concatLines;
  inherit (lib.strings) hasSuffix;
  inherit (lib.filesystem) listFilesRecursive;

  # import each scripts stored in ./scripts
  scripts = map (script: import script { inherit pkgs lib dmenu; }) (
    filter (name: hasSuffix ".nix" name) (listFilesRecursive ./scripts)
  );
  # name attribute from each script forms menu choices
  choices = concatLines (map (script: script.name) scripts);
  # name correspond to its command in bash case block
  commands = concatLines (
    map (script: ''
      "${script.name}")
          ${script.command}
          ;;
    '') scripts
  );
  # the packages as defined in scripts
  packages = map (script: script.package) scripts;

  # the actual dmenu shell script that puts the initial dmenu together
  menu = pkgs.writeShellApplication {
    name = "menu";
    runtimeInputs = [
      dmenu.package
    ];
    text = ''
      choice=$(echo -en "${choices}" | ${dmenu.command} ${dmenu.prompt "Command:"} || exit 0)
      case $choice in
          ${commands}
      esac
    '';
  };
in
{
  home.packages = [
    menu
  ]
  ++ packages;

  wayland.windowManager.sway.config.keybindings = lib.mkIf (systemSettings.wm == "sway") {
    "Mod4+Shift+d" = "exec menu";
  };
  wayland.windowManager.hyprland.extraLuaFiles = lib.mkIf (systemSettings.wm == "hyprland") {
    "dmenu" = {
      content = ''
        hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("menu"))
      '';
      autoLoad = true;
    };
  };
}
