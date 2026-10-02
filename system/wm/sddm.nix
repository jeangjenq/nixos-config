{ pkgs, ... }:
let
  sddm-theme = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [ sddm-theme ];
  };

  environment.systemPackages = [
    sddm-theme
  ];
}
