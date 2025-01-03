{ lib, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      
      background = {
        path = lib.mkForce "screenshot";
        blur_passes=2;
      };

      label = [
        {
          # time
          text="$TIME12";
          font_size = 96;
          shadow_passes = 1;
          # position = "0,300";
          # halign = "center";
          # valign = "center";
        }
        # {
        #   # date
        #   text="cmd[update:1000] date +\"%A, %B %d\"";
        #   font_size = 24;
        #   position = "0,100";
        #   halign = "center";
        #   valign = "center";
        # }
      ];
      
      input-field = {
        fade_on_empty = true;
      };
    };
  };
}