local vars = require("nixvars")
local mod = vars.mod
local menu = vars.menu
local terminal = vars.terminal

hl.bind(
  mod .. " + SHIFT + SPACE",
  hl.dsp.window.float({ action = "toggle" })
)
hl.bind(
  mod .. " + SPACE",
  hl.dsp.window.cycle_next()
)
hl.bind(
  mod .. " + SHIFT + Q",
  hl.dsp.window.close()
)
hl.bind(
  mod .. " + F",
  hl.dsp.window.fullscreen()
)
hl.bind(
  mod .. " + E",
  hl.dsp.layout("rotatesplit")
)

-- focus window with arrows and vim keys
hl.bind(
  mod .. " + left",
  hl.dsp.focus({ direction = "left" })
)
hl.bind(
  mod .. " + right",
  hl.dsp.focus({ direction = "right" })
)
hl.bind(
  mod .. " + up",
  hl.dsp.focus({ direction = "up" })
)
hl.bind(
  mod .. " + down",
  hl.dsp.focus({ direction = "down" })
)
hl.bind(
  mod .. " + h",
  hl.dsp.focus({ direction = "left" })
)
hl.bind(
  mod .. " + l",
  hl.dsp.focus({ direction = "right" })
)
hl.bind(
  mod .. " + j",
  hl.dsp.focus({ direction = "up" })
)
hl.bind(
  mod .. " + k",
  hl.dsp.focus({ direction = "down" })
)

-- move window with arrows and vim keys
hl.bind(
  mod .. " + SHIFT + left",
  hl.dsp.window.move({ direction = "left" })
)
hl.bind(
  mod .. " + SHIFT + right",
  hl.dsp.window.move({ direction = "right" })
)
hl.bind(
  mod .. " + SHIFT + up",
  hl.dsp.window.move({ direction = "up" })
)
hl.bind(
  mod .. " + SHIFT + down",
  hl.dsp.window.move({ direction = "down" })
)
hl.bind(
  mod .. " + SHIFT + h",
  hl.dsp.window.move({ direction = "left" })
)
hl.bind(
  mod .. " + SHIFT + l",
  hl.dsp.window.move({ direction = "right" })
)
hl.bind(
  mod .. " + SHIFT + k",
  hl.dsp.window.move({ direction = "up" })
)
hl.bind(
  mod .. " + SHIFT + j",
  hl.dsp.window.move({ direction = "down" })
)

-- Workspaces
for i = 1, 10 do
  local key = i % 10
  hl.bind(
    mod .. " + " .. key,
    hl.dsp.focus({ workspace = i })
  )
  hl.bind(
    mod .. " + SHIFT + " .. key,
    hl.dsp.window.move({ workspace = i, silent = true })
  )
end

-- scratchpad
hl.bind(
  mod .. " + S",
  hl.dsp.workspace.toggle_special("magic")
)
hl.bind(
  mod .. " + SHIFT + S",
  hl.dsp.window.move({ workspace = "special:magic", silent = true })
)

-- applications
hl.bind(
  mod .. " + RETURN",
  hl.dsp.exec_cmd(terminal)
)
hl.bind(
  mod .. " + D",
  hl.dsp.exec_cmd(menu)
)
hl.bind(
  "CTRL + SHIFT + M",
  hl.dsp.pass({
    window = "class:^discord$"
  })
)

-- media and hardware
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86MonBrightnessUp",
  hl.dsp.exec_cmd("brightnessctl s 10%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("brightnessctl s 10%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioNext",
  hl.dsp.exec_cmd("playerctl next"),
  { locked = true }
)
hl.bind(
  "XF86AudioPause",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { locked = true }
)
hl.bind(
  "XF86AudioPlay",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { locked = true }
)
hl.bind(
  "XF86AudioPrev",
  hl.dsp.exec_cmd("playerctl previous"),
  { locked = true }
)

-- mouse and kb
hl.config({
  binds = { drag_threshold = 10 }
})
hl.bind(
  mod .. " + mouse:272",
  hl.dsp.window.drag(),
  { mouse = true, drag = true }
)
hl.bind(
  mod .. " + mouse:273",
  hl.dsp.window.resize(),
  { mouse = true, drag = true }
)
hl.bind(
  "mouse:275",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "mouse:276",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "mouse:278",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { locked = true }
)
hl.bind(
  mod .. " + C",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true }
)
