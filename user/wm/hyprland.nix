{ pkgs, userSettings, ... }:

{
  imports = [
    ../app/terminal/alacritty.nix
    ../app/terminal/kitty.nix
  ];

  home.packages = with pkgs; [
    kitty # hyprland default terminal
    mako # notification
    rofi-wayland # app launcher
    waybar

    # screenshot
    grim # take screenshot
    slurp # select screenshot region
    satty # screenshot editor
    
    pavucontrol
  ];
  services.blueman-applet.enable = true;

  wayland.windowManager.hyprland = {
    settings = let
      terminal = userSettings.term;
      mod = "SUPER";
    in {
      "$mod" = mod; # choosing a mod key

      monitor = ",preferred,auto,auto";
      
      # initial startups
      exec-once = [
        "waybar"
        "nm-applet --indicator"
        "blueman-applet"
      ];

      general = {
        gaps_in = 5;
	gaps_out = 20;
	border_size = 2;
	"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

	# don't resize window on accidental border click
	resize_on_border = false;

	allow_tearing = false;
	layout = "dwindle";
      };

    };
  };
}
