{
  pkgs,
  lib,
  dmenu,
  name ? "makegif",
  label ? "Convert to GIF",
  source ? "$HOME/Videos",
  extensions ? [
    "mp4"
    "mkv"
    "webm"
  ],
  gifArgs ? lib.concatStrings [
    "fps=12,scale=960:-1:flags=lanczos,"
    # split process into 2 passes
    "split[s0][s1];"
    # first pass determine max color and determine palettes with common color
    "[s0]palettegen=max_colors=32:stats_mode=single:[p];"
    # second pass apply generated palette to video
    "[s1][p]paletteuse=dither=floyd_steinberg"
  ],
  ...
}:
let
  notify = {
    send = lib.concatStringsSep " " [
      "${pkgs.libnotify}/bin/notify-send"
      ''-a "${name}"''
      ''-i "${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16/mimetypes/image-x-gif.svg"''
      "--"
    ];
  };
  # list of video extensions we are going to list
  # build the `find` args that filter out files with supported extensions
  findArgs = lib.concatStringsSep " -o " (map (ext: "-iname '*.${ext}'") extensions);
in
{
  inherit name label;
  description = ''
    List videos in $source and convert them to GIF upon selection.
    Then copy it to clipboard as GIF is likely for pasting.
  '';

  package = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [
      dmenu.package
      pkgs.libnotify
      pkgs.ffmpeg
      pkgs.wl-clipboard
      pkgs.papirus-icon-theme
    ];
    text = ''
      # list of files but output with timestamp, each file separated by null character
      # sort by timestamp
      # cut out original file paths
      # replace null character with newline
      videos=$(find "${source}" -maxdepth 1 \( -type f -o -type l \) \( ${findArgs} \) -printf '%T@ %p\0' |
          sort -z -nr |
          cut -z -d' ' -f2- |
          tr '\0' '\n'
      )
      choice=$(printf "%s" "$videos" | ${dmenu.command} ${dmenu.prompt "${label}"} || exit 0)

      if [[ -n "$choice" ]]; then
          output="''${choice%.*}.gif"
          ${pkgs.ffmpeg}/bin/ffmpeg -y -i "$choice" -vf "${gifArgs}" "$output"
          # copy output to clipboard
          # but as a text uri so electron apps interpret it as a file
          ${pkgs.wl-clipboard}/bin/wl-copy --type text/uri-list "file://$output"
          ${notify.send} "$(basename "$output")" "GIF Conversion done."
      else
          exit 0
      fi
    '';
  };
}
