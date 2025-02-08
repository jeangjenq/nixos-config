{ pkgs, userSettings, ... }:

{
  imports = [
    ../app/terminal/alacritty.nix
    ./swaylock.nix
    ./wlogout.nix
    ./swaync.nix
    ./waybar.nix
    ./ime.nix
  ];

  programs.bemenu = {
    enable = true;
  };

  home.packages = with pkgs; [
    # core
    fuzzel # app launcher
    swaybg # set bg
    sworkstyle # dynamic waybar icons
    polkit_gnome # authentication agent
    brightnessctl # control screen brightness
    playerctl # control media playback

    # screenshot
    grim # take screenshot
    slurp # select screenshot region
    satty # screenshot editor

    # tray control
    networkmanagerapplet   
    pavucontrol
    
    # additionals
    imv
    gnome-calculator # like this calculator
  ];

  wayland.windowManager.sway = {
    enable = true;
  };

  xdg = {
    enable = true;
    configFile."sway" = {
      source = ./swayconfig;
      recursive = true;
    }
  }
}
