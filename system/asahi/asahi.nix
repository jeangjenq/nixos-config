{ inputs, lib, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
  ];

  nixpkgs.overlays = [
    inputs.nixos-apple-silicon.overlays.apple-silicon-overlay
    (final: prev: { mesa = final.mesa-asahi-edge; })
  ];

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
      withRust = true;
      useExperimentalGPUDriver = true;
    };
    graphics.enable = true;
  };

  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
}
