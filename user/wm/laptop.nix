{ pkgs, lib, userSettings, systemSettings, ... }:
let
  lapt = userSettings.monitors.lapt;
  hypr_config = "vrr, 1, cm, auto";

  # WM-specific commands for power-refresh-toggle
  getModesCmd = if systemSettings.wm == "hyprland" then
    ''hyprctl monitors -j | ${pkgs.jq}/bin/jq -r ".[] | select(.name == \"${lapt}\") | .availableModes[]"''
  else
    ''swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r ".[] | select(.name == \"${lapt}\") | .modes[] | \"\(.width)x\(.height)@\(.refresh / 1000 | floor)Hz\""'';

  setHighRefreshCmd = if systemSettings.wm == "hyprland" then
    ''hyprctl keyword monitor "${lapt}, highrr, auto-down, 1.25, ${hypr_config}"''
  else
    ''swaymsg output "${lapt}" mode "$power_mode"'';

  setLowRefreshCmd = if systemSettings.wm == "hyprland" then
    ''hyprctl keyword monitor "${lapt}, $batt_mode, auto-down, 1, ${hypr_config}"''
  else
    ''swaymsg output "${lapt}" mode "$batt_mode" scale 1'';
in
{
  home.packages = lib.optionals (systemSettings.wm == "hyprland") [
    # clamshell script (Hyprland only - Sway handles this via bindswitch)
    (pkgs.writeShellScriptBin "clamshell-toggle" ''
      #!/usr/bin/env bash

      # Read lid state from ACPI
      lid_file="/proc/acpi/button/lid/LID0/state"
      [[ -f "$lid_file" ]] || lid_file="/proc/acpi/button/lid/LID/state"
      if [[ ! -f "$lid_file" ]]; then
        echo "Cannot determine lid state"
        exit 1
      fi

      if grep -q "closed" "$lid_file"; then
        lid_state="closed"
      else
        lid_state="open"
      fi

      echo "Clamshell toggle: lid is $lid_state"

      if [[ "$(hyprctl monitors)" =~ [[:space:]](DP|HDMI)-[A-Za-z0-9]+(-[0-9]+)? ]]; then
        echo "External monitor plugged in."
        if [[ "$lid_state" == "open" ]]; then
          power-refresh-toggle
        else
          hyprctl keyword monitor "${lapt}, disable"
        fi
      else
        echo "External monitor not plugged in, keeping laptop display enabled"
      fi
    '')
  ] ++ [
    # power-aware refresh rate script (works with both Hyprland and Sway)
    (pkgs.writeShellScriptBin "power-refresh-toggle" ''
      #!/usr/bin/env bash

      # Exit early if no power supply exists (likely a desktop)
      shopt -s nullglob
      power_supplies=(/sys/class/power_supply/AC* /sys/class/power_supply/ADP*)
      [[ ''${#power_supplies[@]} -eq 0 ]] && exit 0

      # Check lid state - skip if lid is closed
      lid_file="/proc/acpi/button/lid/LID/state"
      [[ -f "$lid_file" ]] || lid_file="/proc/acpi/button/lid/LID0/state"
      if [[ -f "$lid_file" ]] && grep -q "closed" "$lid_file"; then
        echo "Lid closed - skipping refresh toggle"
        exit 0
      fi

      # Check AC power status
      ac_online=0
      for ac in "''${power_supplies[@]}"; do
        if [[ -f "$ac/online" ]] && [[ "$(<"$ac/online")" == "1" ]]; then
          ac_online=1
          break
        fi
      done

      # Get available modes for the laptop monitor
      modes=$(${getModesCmd})
      power_mode=$(echo "$modes" | head -n1)
      batt_mode=$(echo "$modes" | sed -n '3p')
      # Fallback to first mode if only one available
      [[ -z "$batt_mode" ]] && batt_mode="$power_mode"

      if [[ "$ac_online" == "1" ]]; then
        echo "AC power connected - using high refresh rate: $power_mode"
        ${setHighRefreshCmd}
      else
        echo "On battery - using $batt_mode"
        ${setLowRefreshCmd}
      fi
    '')
  ];

  # systemd user service for power-aware refresh rate
  systemd.user.services.power-refresh = {
    Unit = {
      Description = "Adjust laptop display refresh rate based on power state";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      Environment = [ "PATH=/etc/profiles/per-user/${userSettings.username}/bin:%h/.nix-profile/bin:/run/current-system/sw/bin" ];
      ExecStart = "${pkgs.bash}/bin/bash -c 'power-refresh-toggle'";
    };
  };

  # timer to periodically check power state (sysfs doesn't support inotify reliably)
  systemd.user.timers.power-refresh = {
    Unit = {
      Description = "Check power state periodically";
    };
    Timer = {
      OnBootSec = "5s";
      OnUnitActiveSec = "30s";  # check every 30 seconds
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  # laptop-specific Hyprland settings (merged with main config)
  wayland.windowManager.hyprland.settings = lib.mkIf (systemSettings.wm == "hyprland") {
    # laptop monitor config
    monitor = [
      ("${lapt}, highrr, auto-down, 1.25, ${hypr_config}")
    ];

    # run on every reload
    exec = [
      "power-refresh-toggle"
      "clamshell-toggle"
    ];

    # laptop lid switch binding
    bindl = [
      ", switch:Lid Switch, exec, clamshell-toggle"
    ];

    input = {
      touchpad = {
        natural_scroll = true;
      };
    };

    # touchpad gets adaptive accel
    device = [
      {
        name = "asue120b:00-04f3:31c0-touchpad";
        accel_profile = "adaptive";
      }
      {
        name = "apple-spi-trackpad";
        accel_profile = "adaptive";
      }
      {
        name = "apple-spi-keyboard";
        kb_layout = "us";
        kb_options = "caps:super, altwin:swap_alt_win";
      }
    ];
  };

  # laptop-specific Sway settings (merged with main config)
  wayland.windowManager.sway.config.startup = lib.mkIf (systemSettings.wm == "sway") [
    { command = "power-refresh-toggle"; always = true; }
  ];
}
