{ pkgs, ... }:

{
  programs.swaylock = {
    enable = true;
    settings = {
      "ignore-empty-password" = true;
      "disable-caps-lock-text" = true;
    }
  };
}