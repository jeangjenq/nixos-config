{ pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
    ./ime.nix
    ./ly.nix
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_type = "dmenu";
          chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel -d";
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
