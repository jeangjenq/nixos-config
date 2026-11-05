{ systemSettings, ... }:

{
  programs.workstyle = {
    enable = true;
    systemd = {
      enable = true;
      target = if systemSettings.wm == "sway" then "sway-session.target" else "hyprland-session.target";
    };
    settings = {
      discord = "";
      vesktop = "";
      steam = "";
      Steam = "";
      gamescope = "";
      signal = "";
      mpv = "";
      Gimp = "";
      darktable = "";
      digikam = "";
      kdenlive = "󰴘";
      thunderbird = "";
      nautilus = "";
      pavucontrol = "";
      Chromium = "";
      Slack = "";
      cursor = "";
      firefox = "";
      Alacritty = "";
      kitty = "";
      openscad = "";
      obsidian = "";
      feishin = "";
      other = {
        fallback_icon = "󰣆";
        deduplicate_icons = true;
        separator = " ";
      };
    };
  };
  xdg.configFile."workstyle/config.toml".force = true;
}
