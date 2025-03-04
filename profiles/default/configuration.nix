# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, systemSettings, userSettings, ... }:

{
  imports =
    [ # hardwares
      ../../system/hardware-configuration.nix
      ../../system/hardware/opengl.nix
      ../../system/hardware/bluetooth.nix
      ../../system/hardware/printing.nix
      ../../system/hardware/automount.nix
      ../../system/hardware/8bitdo.nix
      ../../system/network/wireguard.nix
      
      ../../system/game/steam.nix
      ../../system/game/heroic.nix
      ../../system/game/gamemode.nix
      ../../system/app/electron-wrapper.nix

      ( ./. + "../../../system/wm" + ("/" + systemSettings.wm) + ".nix" )
      
      ../../system/app/docker.nix
      ../../system/virtualization/virtualization.nix

      # sshd for setting up nixos in vm
      (import ../../system/network/sshd.nix {
        authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEQnJVdL98B5voLeFHF9pGhNBW6mudDPJM2By159a/6 jeangjenq@worf"];
        inherit userSettings; })
    ];

  # personal preferences on powerkey and suspend behaviour
  services.logind = {
    powerKey = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  # enable flatpak for something like discord
  services.flatpak.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = systemSettings.hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = systemSettings.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.username;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [];
    uid = 1000;
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    git
    home-manager
  ];

  # Enable the OpenSSH daemon.
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
