{
  pkgs,
  lib,
  dmenu,
  ...
}:
let
  command = "wallpaper-picker";
  inherit (lib) concatStringsSep concatMap;
  # list of extensions we might use and awww supports
  extensions = [
    "jpg"
    "png"
    "gif"
    "svg"
    "webp"
  ];
  # build the `find` args that filter out files with supported extensions
  args = concatStringsSep " " (
    concatMap (ext: [
      "-o"
      "-iname"
      "'*.${ext}'"
    ]) extensions
  );
in
{
  name = "Wallpapers";
  inherit command;
  description = ''
    Show available wallpapers in ~/Pictures/wallpapers and switch with `awww img`.
    Hardcoded rofi syntax.
  '';
  package = pkgs.writeShellScriptBin "${command}" ''
    wallpapers=$(find "$HOME/Pictures/wallpapers" -type f ${args})
    choice=$(for a in $wallpapers; do echo -en "$a\0icon\x1f$a\n"; done | ${dmenu} -theme fullscreen-preview || exit 0)
    [[ -n "$choice" ]] || exit 0
    awww img "$choice" --transition-type any --transition-fps 90
  '';
}
