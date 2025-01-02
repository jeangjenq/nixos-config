{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerdfonts
    font-awesome # waybar default
    roboto-mono # waybar theme at this time
    noto-fonts # google font
    noto-fonts-color-emoji
    liberation_ttf # opensource Arial for steam UI
    # chinese fonts
    noto-fonts-cjk-sans # google chinese font
    noto-fonts-cjk-serif # google chinese font
  ];
}
