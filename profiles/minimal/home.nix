{ pkgs, pkgs-stable, systemSettings, userSettings, ... }:

{

  imports = [
    ( ./. + "../../../user/wm" + ( "/" + systemSettings.wm + ".nix") )
    (./. + "../../../user/shell" + ("/" + userSettings.term) + ".nix")
    ../../user/app/git/git.nix
    ../../user/shell/sh.nix
    ../../user/shell/yazi.nix
    ../../user/shell/helix.nix
    ../../user/virtualization/virtualization.nix
    ../../user/app/browser/firefox.nix
    ../../themes/stylix.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  home.stateVersion = "24.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;

  programs.firefox.enable = true;
  
  home.packages = (with pkgs; [
    # core
    adwaita-icon-theme
    mission-center
  ])
  ++
  (with pkgs-stable ;[
  ]);

  home.sessionVariables = {
  };

  xdg.configFile."mimeapps.list".force = true;

}
