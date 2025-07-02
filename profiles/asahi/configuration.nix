{ config, pkgs, systemSettings, userSettings, ... }:

{
  imports =
    [ # hardwares
      ../../system/hardware-configuration.nix
      ../../system/hardware/bluetooth.nix
      ../../system/hardware/printing.nix
      ../../system/hardware/automount.nix
      ../../system/network/wireguard.nix
      ../../system/virtualization/virtualization.nix

      ../../system/asahi/asahi.nix

      ../../system/app/electron-wrapper.nix
      ( ./. + "../../../system/wm" + ("/" + systemSettings.wm) + ".nix" )
    ];

  # personal preferences on powerkey and suspend behaviour
  services.logind = {
    powerKey = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.efi.canTouchEfiVariables = false;

  # Enable networking
  networking.hostName = systemSettings.hostname; # Define your hostname.
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

  system.stateVersion = "24.11"; # Did you read the comment?

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
