{
  pkgs,
  lib,
  ...
}:
let
  screenshot = import ./screenshot.nix { inherit pkgs; };
  grab = "${screenshot.grab}/bin/screengrab";
  shot = "${screenshot.shot}/bin/screenshot";
  buttons = [
    {
      label = "󰐥";
      "command" = "${pkgs.wlogout}/bin/wlogout";
    }
    {
      label = "";
      "command" = "${shot}";
    }
    {
      label = "";
      "command" = "${grab}";
    }
    {
      label = "";
      "command" = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
    }
    {
      label = "";
      "command" = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle";
    }
  ];
in
{
  services.swaync = {
    enable = true;
    settings = {
      layer = "overlay";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-left = 10;
      control-center-margin-right = 10;
      hide-on-clear = true;
      transition-time = 100;
      widgets = [
        "mpris"
        "buttons-grid"
        "volume"
        "title"
        "dnd"
        "notifications"
      ];
      widget-config = {
        volume = {
          label = "";
          show-per-app = true;
          show-per-app-label = true;
          expand-per-app = true;
          animation-duration = 100;
        };
        mpris = {
          # avoid duplicates
          blacklist = [
            "playerctl"
          ];
        };
        buttons-grid = {
          buttons-per-row = builtins.length buttons;
          actions = buttons;
        };
      };
    };

    # disable the round mask around notification icons
    style = lib.mkAfter ''
      .notification-row
      .notification-background
      .notification
      .notification-default-action
      .notification-content
      .image {
          border-radius: 0;
      }
    '';
  };

  # Hyprland startup and keybinding
  wayland.windowManager.hyprland = {
    extraLuaFiles = {
      "swaync" = {
        content = ''
          hl.bind(
            "SUPER + Tab",
            hl.dsp.exec_cmd("swaync-client -t -sw")
          )
        '';
        autoLoad = true;
      };
    };
  };

  # Sway startup and keybindings
  wayland.windowManager.sway = {
    config = {
      keybindings = {
        "Mod4+tab" = "exec swaync-client -t -sw"; # toggle notification panel
      };
    };
  };
}
