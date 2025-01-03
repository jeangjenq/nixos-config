{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    defaultTimeout = 0;
    ignoreTimeout = true;
    extraConfig = ''
      [mode=away]
    '';
  };
}
