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
    casks = [
      # better than spotlight?
      "raycast"

      # comms
      "firefox"
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

  # specify user
  users.users."${userSettings.username}" = {
    home = "/Users/" + userSettings.username;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # use TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true; 

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
}
