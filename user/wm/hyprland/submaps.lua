-- "resize": window resizing hotkeys
hl.bind("SUPER + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
  hl.bind(
    "right",
    hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true }
  )
  hl.bind(
    "left",
    hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true }
  )
  hl.bind(
    "up",
    hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true }
  )
  hl.bind(
    "down",
    hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true }
  )
  hl.bind(
    "SHIFT+right",
    hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true }
  )
  hl.bind(
    "SHIFT+left",
    hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true }
  )
  hl.bind(
    "SHIFT+up",
    hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true }
  )
  hl.bind(
    "SHIFT+down",
    hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true }
  )

  hl.bind("escape", hl.dsp.submap("reset"))
end)


-- "passthrough": nothing, just for using remote machines
hl.bind("CTRL+ALT+SHIFT+Z", hl.dsp.submap("passthrough"))

hl.define_submap("passthrough", function()
  hl.bind("escape", hl.dsp.submap("reset"))
end)
