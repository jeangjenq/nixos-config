{ lib, pkgs, userSettings, ... }:
# this profile is just work + games, players... personal use stuff

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
  imports = [
    ../work/configuration.nix
    ../../system/hardware-configuration.nix
    ../../system/hardware/automount.nix
    ../../system/game/steam.nix
    ../../system/game/heroic.nix
    ../../system/game/gamemode.nix

    # sshd for setting up nixos in vm
    (import ../../system/network/sshd.nix {
      authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEQnJVdL98B5voLeFHF9pGhNBW6mudDPJM2By159a/6 jeangjenq@worf"];
      inherit userSettings; })
  ];
    
  # enable flatpak for something like discord
  services.flatpak.enable = true;

  # electron apps that needs wrapper
  users.users.${userSettings.username}.packages = [
    signal
    tidal
  ];
}
