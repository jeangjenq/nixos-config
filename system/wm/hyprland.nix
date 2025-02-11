{ pkgs, systemSettings, ... }:

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
    # optional to use google/nextcloud calendar
    evolution-data-server.enable = true;
    gnome-online-accounts.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
