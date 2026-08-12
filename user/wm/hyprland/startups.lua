hl.on("hyprland.start", function()
  -- essentials
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("protonmail-bridge --noninteractive")
  hl.exec_cmd("nextcloud")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  -- preferences
  hl.exec_cmd("[workspace 1] firefox")
  hl.exec_cmd("[workspace 5 silent] MANGOHUD=1 steam")
  hl.exec_cmd("[workspace 6 silent] discord")
  hl.exec_cmd("[workspace 7 silent] signal-desktop")
  hl.exec_cmd("[workspace 8 silent] sleep 10 && thunderbird")
  hl.exec_cmd("[workspace 9 silent] feishin")
end)
