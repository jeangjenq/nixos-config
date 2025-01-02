{ pkgs, ... }:

{
  imports = [
    ./pipewire.nix
  ];

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.displayManager.ly = {
    enable = true;
  };
}
