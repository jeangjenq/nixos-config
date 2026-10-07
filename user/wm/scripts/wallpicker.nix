{
  pkgs,
  lib,
  ...
}:
let
  command = "wallpaper-picker";
  # list of extensions we might use and awww supports
  extensions = [
    "jpg"
    "png"
    "gif"
    "svg"
    "webp"
  ];
  # build the `find` args that filter out files with supported extensions
  args = lib.concatStringsSep " -o " (map (ext: "-iname '*.${ext}'") extensions);
  rofi-theme = ''
    window {
        width: 1200px;
        height: 800px;
    }

    element-icon {
        size: 120px;
        border-radius: 8px;
        padding: 2px;
    }

    element-text {
        vertical-align: 0.5;
    }
  '';
in
{
  name = "Wallpapers";
  inherit command;
  description = ''
    Show available wallpapers in ~/Pictures/wallpapers and switch with `awww img`.
    Hardcoded rofi syntax.
  '';
  package = pkgs.writeShellApplication {
    name = command;
    runtimeInputs = with pkgs; [
      libnotify
      rofi
    ];
    text = ''
      WALLPAPER_DIR="$HOME/Pictures/wallpapers"

      if [[ ! -d "$WALLPAPER_DIR" ]]; then
          ${pkgs.libnotify}/bin/notify-send "Wallpaper directory not found: $WALLPAPER_DIR"
          exit 0
      fi

      # present choices of wallpapers
      wallpaper_name=$(find "$WALLPAPER_DIR" \( -type f -o -type l \) \( ${args} \) | while IFS= read -r file; do
          # show name without file extension
          name="''${file##*/}"
          pretty_name="''${name%.*}"
          # format for rofi icon preview
          # this also make rofi return file basename instead of fullpath
          printf '%s\0icon\x1f%s\n' "$pretty_name" "$file"
      done | ${pkgs.rofi}/bin/rofi -dmenu -i -p "Select Wallpaper:" -show-icons -theme-str '${rofi-theme}' || exit 0)

      if [[ -n "$wallpaper_name" ]]; then
          # we have to refind the wallpaper with the matching name
          echo "Looking for wallpaper with the name of '$wallpaper_name'"
          wallpaper_path=$(find "$WALLPAPER_DIR" \( -type f -o -type l \) \( ${args} \) -name "$wallpaper_name.*" | head -n 1)
          if [[ -n "$wallpaper_path" ]]; then
              echo "Wallpaper picked: '$wallpaper_path'"
              awww img "$wallpaper_path" --transition-type any --transition-fps 90
          else
              ${pkgs.libnotify}/bin/notify-send "Wallpaper picker error: Could not locate '$wallpaper_name'"
          fi
      else
          exit 0
      fi
    '';
  };
}
