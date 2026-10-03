{
  lib,
  pkgs,
  config,
  systemSettings,
  ...
}:

let
  lockCommands = {
    hyprland = "hyprlock";
    sway = "swaylock -f";
  };
  lockCommand = lockCommands.${systemSettings.wm} or "swaylock -f";
  inherit (config.lib.stylix.colors.withHashtag)
    base00
    base02
    base04
    ;
in
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "o";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "lock";
        action = lockCommand;
        text = "Lock";
        keybind = "l";
      }
    ];
    style = ''
      * {
          background-image: none;
      }

      window {
          background-color: alpha(${base00}, 0.45);
      }

      button {
          border-radius: 30px;
          margin: 20px;
          outline-style: none;
          background-color: alpha(${base02}, 0.8);
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          box-shadow: none;
          text-shadow: none;
          animation: gradient_f 20s ease-in infinite;
      }

      button:hover,button:focus {
          background-color: ${base04};
          background-size: 30%;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
      }

      button span {
          font-size: 1.2em;
      }

      #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }
      #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }
      #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }
      #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }
      #lock {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }
    '';
  };

  # Sway keybinding for wlogout
  wayland.windowManager.sway.config = lib.mkIf (systemSettings.wm == "sway") {
    keybindings = {
      "Mod4+Shift+e" = "exec wlogout -p layer-shell";
    };
  };

  # Hyprland keybinding for wlogout
  wayland.windowManager.hyprland.settings.bind = lib.mkIf (systemSettings.wm == "hyprland") [
    {
      _args = [
        "SUPER + SHIFT + E"
        (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wlogout\")")
      ];
    }
  ];
}
