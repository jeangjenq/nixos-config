{ pkgs, ... }:

{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      "ignore-empty-password" = true;
      "disable-caps-lock-text" = true;
    };
  };
}
