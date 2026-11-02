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
      "-a measure-size"
      ''-i "${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16/apps/kruler.svg"''
      "--"
    ];
  };
in
rec {
  name = "measure-screen";
  label = "Measure pixels on screen";

  package = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [
      dmenu.package
      pkgs.libnotify
      pkgs.slurp
    ];
    text = ''
      size=$(slurp | awk '{print $2}')
      ${notify.send} "$size" "Measured pixels"
    '';
  };
}
