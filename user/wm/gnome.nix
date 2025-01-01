{ ... }:

{
  dconf.settings = {
    
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };
    
    # don't track my file history but auto clear temp and trash
    "org/gnome/desktop/privacy" = {
      recent-files-max-age = -1;
      remember-recent-files = false;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
    
    # only turn off screen after idling 10 minutes
    "org/gnome/desktop/session" = {
      idle-delay = 600;
    };
    
    # never auto-suspend when powered
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    
    # activate appindicator extension, assuming it's installed
    "org/gnome/shell" = {
      enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
    }; 
  };
}
