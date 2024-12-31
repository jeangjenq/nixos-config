{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libreoffice
    hunspell
  ];
}
