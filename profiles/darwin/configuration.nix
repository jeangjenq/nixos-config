{ pkgs, systemSettings, userSettings, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    home-manager
  ];

  homebrew = {
    enable = true;
    casks = [
      # better than spotlight?
      "raycast"

      # comms
      "thunderbird"
      "signal"
      "discord"

      # media
      "tidal"

      # dev
      "vmware-fusion"
    ];
    masApps = {
      "bitwarden" = 1352778147;
      "wireguard" = 1451685025;
    };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  system.defaults = {
    dock.autohide = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # use TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true; 

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # make sure rosetta is enabled so we can run binaries for intel-cpus
  system.activationScripts.extraActivation.text = ''
    softwareupdate --install-rosetta --agree-to-license
  '';
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
