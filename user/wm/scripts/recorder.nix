{
  pkgs,
  lib,
  dmenu,
  ...
}:
let
  command = "record-screen";
  regions = lib.concatLines [
    "Whole screen"
    "Selected region"
  ];
  flags = lib.concatStringsSep " " [
    "-y" # overwrite without question
    "-c" # specifying codec
    "h264_vaapi"
  ];
in
{
  name = "Start/stop screen record";
  inherit command;
  description = ''
    Starts or stop a screen recording session,
    with prompt to screen record whole screen or a region.
  '';

  package = pkgs.writeShellApplication {
    name = command;
    runtimeInputs = [
      dmenu.package
      pkgs.wf-recorder
      pkgs.ffmpeg
      pkgs.slurp
      pkgs.libnotify
    ];
    text = ''
      # check for existing wf-recorder
      if ! pgrep -x wf-recorder > /dev/null; then
          choice=$(printf "${regions}" | ${dmenu.command} ${dmenu.prompt "Start a screen recording of:"})
          filename="$HOME/Videos/$(date +'recording_%Y-%m-%d_%H%M%S')"
          case "$choice" in
              "Whole screen")
                  ${pkgs.libnotify}/bin/notify-send "Recording started on '$choice'"
                  ${pkgs.wf-recorder}/bin/wf-recorder ${flags} -f "$filename.mp4"
                  ;;
              "Selected region")
                  region="$(${pkgs.slurp}/bin/slurp)"
                  if [[ -n "$region" ]]; then
                      ${pkgs.libnotify}/bin/notify-send "Recording started on '$choice'"
                      ${pkgs.wf-recorder}/bin/wf-recorder -g "$region" ${flags} -f "$filename.mp4"
                  else
                      ${pkgs.libnotify}/bin/notify-send "Recording region not selected!"
                      exit 1
                  fi
                  ;;
          esac
      else
          # send a gentle SIGINT like pressing CTRL+C on terminal
          pkill -2 wf-recorder
          ${pkgs.libnotify}/bin/notify-send "Recording stopped."
      fi
    '';
  };
}
