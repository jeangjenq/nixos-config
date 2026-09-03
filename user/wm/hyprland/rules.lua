hl.layer_rule({
    match = { namespace = "logout_dialog" },
    blur = true,
})

-- steam games
hl.window_rule({
    match = { initial_title = "^Steam$" },
    monitor = 0,
    workspace = "5 silent",
})
hl.window_rule({
    match = { class = "^steam$" },
    monitor = 0,
    workspace = "5 silent",
})
hl.window_rule({
    match = {
        class = "^steam$",
        title = "negative:^Steam$",
    },
    monitor = 0,
    workspace = "5 silent",
    float = true,
    opacity = 0.9,
})
hl.window_rule({
    match = {
        class = "^steam$",
        title = "^(notificationtoasts_.*_desktop)$",
    },
    no_focus = true,
    -- pin = true,
    opacity = 0.6,
})
hl.window_rule({
    match = { class = "^(steam_app_.*)|^(gamescope)" },
    monitor = 0,
    fullscreen = true,
    immediate = true,
    decorate = false,
    no_anim = true,
    idle_inhibit = "always",
    render_unfocused = true,
})

-- pop ups
hl.window_rule({
    match = { class = "^(xdg.desktop-portal)" },
    float = true,
    opacity = 0.85,
})
hl.window_rule({
    match = { title = "^(Open|Save) (File|Folder|As).+" },
    float = true,
    opacity = 0.85,
})
hl.window_rule({
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true,
    opacity = 0.85,
})
hl.window_rule({
    match = {
        class = "^[tT]hunar",
        title = "^(File Operation Progress)",
    },
    float = true,
    opacity = 0.85,
})
hl.window_rule({
    match = {
        class = "firefox",
        title = "Picture-in-Picture",
    },
    float = true,
})

-- workspace assignments
hl.window_rule({
    match = { class = "vesktop|discord" },
    monitor = 1,
    workspace = "6 silent",
})
hl.window_rule({
    match = { class = "^(teams-for-linux)$" },
    monitor = 1,
    workspace = 6,
})
hl.window_rule({
    match = {
        class = "signal",
        title = "Signal",
    },
    monitor = 1,
    workspace = "7 silent",
})
hl.window_rule({
    match = { class = "thunderbird" },
    monitor = 1,
    workspace = "8 silent",
})
hl.window_rule({
    match = { class = "(tidal-hifi)|(feishin)" },
    monitor = 1,
    workspace = 9,
    opacity = 0.95,
})
hl.window_rule({
    match = { class = "^(pcoip-client)$" },
    monitor = 0,
    workspace = "10 silent",
})

-- some special treatments
hl.window_rule({
    match = {
        class = "^org.speedcrunch.$",
        title = "^SpeedCrunch$",
    },
    float = true,
})
hl.window_rule({
    match = { class = "^org.gnome.Cal.+" },
    float = true,
})
hl.window_rule({
    match = { class = "^com.nextcloud.desktopclient.nextcloud$" },
    opacity = 0.85,
    float = true,
    stay_focused = true,
})
hl.window_rule({
    match = { class = "^(io.missioncenter.MissionCenter)$" },
    float = true,
    opacity = 0.85,
})

hl.window_rule({
    match = { class = "^org.gnome..+" },
    opacity = 0.85,
})
