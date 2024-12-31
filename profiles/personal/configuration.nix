{ userSettings, ... }:
# this profile is just work + games, players... personal use stuff
{
  imports = [
    ../work/configuration.nix
    ../../system/hardware-configuration.nix
    ../../system/game/steam.nix
    ../../system/game/heroic.nix
    ../../system/game/gamemode.nix

    # sshd for setting up nixos in vm
    (import ../../system/network/sshd.nix {
      authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAlJlA2WwrobWq0eq1UKfiJd/+e7HyTp13mzl0fP/e/b jeangjenq@worf"];
      inherit userSettings; })
  ];
}
