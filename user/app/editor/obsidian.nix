{ pkgs, ... }:

{
  home.packages = [
    pkgs.obsidian
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/obsidian" = "md.obsidian.Obsidian.desktop";
    };
  };

  wayland.windowManager.sway.config.window.commands = [
    {
      criteria = {
        app_id = "md\\.obsidian\\.Obsidian";
      };
      command = "focus_on_window_activation focus";
    }
  ];

  wayland.windowManager.hyprland.settings.config.misc = {
    focus_on_activate = true;
  };
}
