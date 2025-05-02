{ inputs, lib, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
  ];

  # nixpkgs.overlays = [
  #   inputs.nixos-apple-silicon.overlays.apple-silicon-overlay
  #   (final: prev: { mesa = final.mesa-asahi-edge; })
  # ];

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
      useExperimentalGPUDriver = true;
    };
    graphics.enable = true;
  };

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  # swap fn and control key
  boot.extraModprobeConfig = "options hid_apple swap_fn_leftctrl=1";

  # fix an issue where gtk applications can't detect wayland display
  environment.sessionVariables = {
    GSK_RENDERER="gl";
  };
}
