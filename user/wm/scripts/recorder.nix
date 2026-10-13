{
  pkgs,
  lib,
  dmenu,
  ...
}:
let
  notify = {
    send = "${pkgs.libnotify}/bin/notify-send -a wf-recorder";
    icon = {
      start = ''-i "${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16/apps/simplescreenrecorder.svg"'';
      stop = ''-i "${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16/apps/green-recorder.svg"'';
      error = ''-i "${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16/panel/simplescreenrecorder-error.svg"'';
    };
  };
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
rec {
  name = "record-screen";
  label = "Start/stop screen record";
  description = ''
    Starts or stop a screen recording session,
    with prompt to screen record whole screen or a region.
  '';

  package = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [
      dmenu.package
      pkgs.wf-recorder
      pkgs.ffmpeg
      pkgs.slurp
      pkgs.libnotify
      pkgs.papirus-icon-theme
    ];
    text = ''
      # check for existing wf-recorder
      if ! pgrep -x wf-recorder > /dev/null; then
          choice=$(printf "${regions}" | ${dmenu.command} ${dmenu.prompt "Start a screen recording of:"})
          filename="$HOME/Videos/$(date +'recording_%Y-%m-%d_%H%M%S')"
          case "$choice" in
              "Whole screen")
                  ${notify.send} ${notify.icon.start} -- "Recording started."
                  ${pkgs.wf-recorder}/bin/wf-recorder ${flags} -f "$filename.mp4"
                  ;;
              "Selected region")
                  region="$(${pkgs.slurp}/bin/slurp)"
                  if [[ -n "$region" ]]; then
                      ${notify.send} ${notify.icon.start} -- "Recording started."
                      ${pkgs.wf-recorder}/bin/wf-recorder -g "$region" ${flags} -f "$filename.mp4"
                  else
                      ${notify.send} ${notify.icon.error} -- "Recording region not selected."
                      exit 1
                  fi
                  ;;
          esac
      else
          # send a gentle SIGINT like pressing CTRL+C on terminal
          pkill -2 wf-recorder
          ${notify.send} ${notify.icon.stop} -- "Recording stopped."
      fi
    '';
  };
}
