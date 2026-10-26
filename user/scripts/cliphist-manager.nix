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
      "-a cliphist"
      "-i ${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16/emblems/vcs-conflicting.svg"
      "--"
    ];
  };
in
rec {
  name = "cliphist-manager";
  label = "Manage cliphist data";
  description = ''
    Wipe options for cliphist.
  '';

  package = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [
      dmenu.package
      pkgs.cliphist
      pkgs.libnotify
    ];

    text = ''
      choice=$(printf "Delete single entry\nWipe older than\nWipe history" | \
        ${dmenu.command} ${dmenu.prompt "Clipboard history:"} || exit 0)

      case "$choice" in
          "Delete single entry")
              cliphist list | ${dmenu.command} ${dmenu.prompt "Delete history:"} | cliphist delete
              ;;
          "Wipe older than")
              hours=$(${dmenu.command} ${dmenu.prompt "Older than (s/m/h)"})
              if [[ "$hours" =~ ^\.?[0-9]+(\.[0-9]+)?[smh]$ ]]; then
                  cliphist wipe -older-than "$hours"
              else
                  ${notify.send} "Invalid duration!" "Entered number must end in s/m/h."
              fi
              ;;
          "Wipe history")
              cliphist wipe
              ;;
      esac
      # might as well compact database
      cliphist compact
    '';
  };
}
