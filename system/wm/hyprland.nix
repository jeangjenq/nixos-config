{ pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
    ./ime.nix
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

  services.gnome = {
    gnome-keyring.enable = true;
    # optional to use google/nextcloud calendar
    evolution-data-server.enable = true;
    gnome-online-accounts.enable = true;
  };

  services.displayManager.ly = {
    enable = true;
  };
}
