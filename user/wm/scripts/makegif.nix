{
  pkgs,
  lib,
  dmenu,
  ...
}:
let
  command = "makegif";
  # list of video extensions we are going to list
  extensions = [
    "mp4"
    "mkv"
    "webm"
  ];
  # build the `find` args that filter out files with supported extensions
  findArgs = lib.concatStringsSep " -o " (map (ext: "-iname '*.${ext}'") extensions);
  gifArgs = lib.concatStrings [
    "fps=12,scale=960:-1:flags=lanczos,"
    # split process into 2 passes
    "split[s0][s1];"
    # first pass determine max color and determine palettes with common color
    "[s0]palettegen=max_colors=32:stats_mode=single:[p];"
    # second pass apply generated palette to video
    "[s1][p]paletteuse=dither=floyd_steinberg"
  ];
in
{
  name = "Convert to GIF";
  inherit command;
  description = ''
    List videos in ~/Videos and convert them to GIF upon selection.
    Then copy it to clipboard as GIF is likely for pasting.
  '';

  package = pkgs.writeShellApplication {
    name = command;
    runtimeInputs = [
      dmenu.package
      pkgs.ffmpeg
      pkgs.libnotify
      pkgs.wl-clipboard
    ];
    text = ''
      # list of files but output with timestamp, each file separated by null character
      # sort by timestamp
      # cut out original file paths
      # replace null character with newline
      videos=$(find "$HOME/Videos" -maxdepth 1 \( -type f -o -type l \) \( ${findArgs} \) -printf '%T@ %p\0' |
          sort -z -nr |
          cut -z -d' ' -f2- |
          tr '\0' '\n'
      )
      choice=$(printf "%s" "$videos" | ${dmenu.command} ${dmenu.prompt "Convert to GIF:"} || exit 0)

      if [[ -n "$choice" ]]; then
          output="''${choice%.*}.gif"
          ${pkgs.ffmpeg}/bin/ffmpeg -y -i "$choice" -vf "${gifArgs}" "$output"
          ${pkgs.wl-clipboard}/bin/wl-copy --type text/uri-list "file://$output"
          ${pkgs.libnotify}/bin/notify-send "$(basename "$output") done."
      else
          exit 0
      fi
    '';
  };
}
