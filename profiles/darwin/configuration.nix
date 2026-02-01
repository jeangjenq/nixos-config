{ pkgs, lib, systemSettings, userSettings, ... }:
let
  firefoxConfig = import ../../user/app/browser/firefox.nix { inherit lib pkgs userSettings; };
  firefoxJson = builtins.toJSON firefoxConfig.programs.firefox.policies;
  firefoxPolicies = pkgs.writeTextFile {
    name = "policies.json";
    text = ''
      {"policies":${firefoxJson}}
    '';
    destination = "/policies.json";
  };
  firefoxPoliciesDir = "/Applications/Firefox.app/Contents/Resources/distribution/";
in
{
  imports = [
  ];

  # stylix is not gonna set background
  # but just using an image to create color palette
  stylix.enable = true;
  stylix.image = ../../themes/wallpaper/albertbierstadt.jpg;
  stylix.polarity = "dark";
  # terminal opacity, very important
  stylix.opacity = {
    popups = 0.8;
    terminal = 0.85;
  };
  
  # actual packages
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    home-manager
  ];

  # dumping firefox policies to /etc/firefox/policies.json
  # NOTE: Could not figure out how to link policies.json into
  # /Applications/Firefox.app/Contents/Resources/distribution/
  # manual mkdir and symlink later
  # sudo ln -s /etc/firefox/policies.json /Applications/Firefox.app/Contents/Resources/distribution/policies.json
  environment.etc."firefox".source = firefoxPolicies;

  homebrew = {
    enable = true;
    brews = [
      "exiftool"
    ];
    casks = [
      # better than spotlight?
      "raycast"

      # comms
      "firefox"
      "thunderbird"
      "signal"
      "protonvpn"
      "discord"

      # media
      "digikam"
      "darktable"
      "tidal"
      "jellyfin-media-player"
      "steam"
      "nextcloud"

      # work
      "libreoffice"
      "docker-desktop"
      "ollama-app"
      "cursor"
      "obsidian"
      "bambu-studio"
      "vial"
    ];

    masApps = {
      "wireguard" = 1451685025;
    };
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };

  system.defaults = {
    dock.autohide = true;
    dock.static-only = false;
    dock.show-recents = false;
    dock.persistent-apps = [];
    finder.ShowPathbar = true;
    menuExtraClock.Show24Hour = true;
    menuExtraClock.ShowSeconds = true;
    menuExtraClock.ShowDayOfWeek = true;
    # pressing fn key shouldn't do shit
    hitoolbox.AppleFnUsageType = "Do Nothing";
    # remove trash after 30 days
    finder.FXRemoveOldTrashItems = true;
    controlcenter.BatteryShowPercentage = true;
    # Whether to enable moving window by holding anywhere on it like on Linux.
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    # use function keys as media control first
    NSGlobalDomain."com.apple.keyboard.fnState" = false;
    # don't touch what I type
    NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
    NSGlobalDomain.NSAutomaticInlinePredictionEnabled = false;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };

  # specify user
  users.users."${userSettings.username}" = {
    home = "/Users/" + userSettings.username;
  };
  system.primaryUser = userSettings.username;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # use TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true; 

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

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
  nixpkgs.config.allowUnsupportedSystem = true;
}
