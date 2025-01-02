{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    ttf-font-awesome # waybar default
    ttf-roboto-mono # waybar theme at this time
    noto-fonts # google font
    noto-fonts-emoji
    ttf-liberation # opensource Arial for steam UI
    # various chinese fonts
    noto-fonts-cjk # google chinese font
    adobe-source-han-sans-cn-fonts
    adobe-source-han-sans-tw-fonts
    adobe-source-han-sans-hk-fonts
    adobe-source-han-serif-cn-fonts
    adobe-source-han-serif-tw-fonts
    adobe-source-han-serif-hk-fonts
    ttf-hannom
  ];
}
