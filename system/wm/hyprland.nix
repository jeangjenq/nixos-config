{ pkgs, systemSettings, ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
    ./ime.nix
    ./ly.nix
  ];

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = (if (systemSettings.system == "aarch64-linux") then false else true);
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

  services.gnome = {
    gnome-keyring.enable = true;
  };
}
