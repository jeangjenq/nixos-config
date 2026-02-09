{ lib, pkgs, ... }:

let
  # screw all these electron app fuckery
  # https://discourse.nixos.org/t/how-to-write-a-electron-app-wrap-function/40581
  warp = { appName }:
    pkgs.symlinkJoin {
      name = appName;
      paths = [ pkgs.${appName} ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = lib.strings.concatStrings [
        "wrapProgram $out/bin/"
        appName
        " --add-flags \"--enable-wayland-ime\""
      ];
    };

    signal = warp { appName = "signal-desktop"; };
    tidal = warp { appName = "tidal-hifi"; };

in

{
  home.packages = [
    signal
    tidal
  ];
}
