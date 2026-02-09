{ pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
    ./ime.nix
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd sway";
        user = "greeter";
      };
    };
  };
}
