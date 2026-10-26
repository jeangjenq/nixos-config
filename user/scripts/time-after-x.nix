{
  pkgs,
  lib,
  dmenu,
  ...
}:
let
  notify = {
    send = lib.concatStringsSep " " [
      "notify-send"
      "-a time-after-x"
      ''-i "${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16/apps/preferences-system-time.svg"''
      "--"
    ];
  };
in
rec {
  name = "time-after-x";
  label = "Time after X hours";
  description = ''
    Answers simple question of
    "What time is if after X hours?"
  '';

  package = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [
      dmenu.package
      pkgs.libnotify
    ];
    text = ''
      hours=$(${dmenu.command} ${dmenu.prompt "Time after how many hours?"})

      [[ -z "$hours" ]] && exit 0

      if [[ "$hours" =~ ^\.?[0-9]+(\.[0-9]+)?$ ]]; then
          seconds=$(awk -v h="$hours" 'BEGIN { printf "%.0f", h * 3600 }')
          result=$(date -d "+''${seconds} seconds" "+%H:%M")
          ${notify.send} "$result" "after $hours hours"
      else
          ${notify.send} "$hours is not a valid number."
      fi
    '';
  };
}
