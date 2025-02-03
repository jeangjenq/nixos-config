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

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
