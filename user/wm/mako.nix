{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    extraConfig = ''
      [mode=away]
      default-timeout=0
      ignore-timeout=1
    '';
  };
}