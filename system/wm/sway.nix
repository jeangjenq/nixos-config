{ pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./stylix.nix
    ./dbus.nix
    ./fonts.nix
    ./sddm.nix
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  # fix an issue with svg render as red block in some places
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  security.polkit.enable = true;
  security.pam.services.hyprlock = { };

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_type = "dmenu";
          chooser_cmd = "${pkgs.rofi}/bin/rofi -dmenu";
        };
      };
    };
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
