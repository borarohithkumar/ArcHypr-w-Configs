-- =============================================================================
-- WINDOW & LAYER RULES
-- =============================================================================

-- 1. Centered Floating Utility Dialogs
local center_floats = {
    { name = "pavucontrol",           class = ".*org.pulseaudio.pavucontrol.*", size = "700 600",  pin = true },
    { name = "waypaper",              class = ".*waypaper.*",                   size = "900 700",  pin = true },
    { name = "newelle",               class = "io.github.qwersyk.Newelle",      size = "1000 700", pin = true },
    { name = "blueman-manager",       class = "blueman-manager",                size = "800 600",  pin = false },
    { name = "nwg-look",              class = "nwg-look",                       size = "700 600",  pin = false },
    { name = "nwg-displays",          class = "nwg-displays",                   size = "900 600",  pin = false },
    { name = "missioncenter",         class = "io.missioncenter.MissionCenter", size = "900 600",  pin = true },
    { name = "gnome-calculator",      class = "org.gnome.Calculator",           size = "700 600",  pin = false },
    { name = "hyprland-share-picker", class = "hyprland-share-picker",          size = "600 400",  pin = true },
    { name = "nm-connection-editor",  class = "nm-connection-editor",           size = "800 700",  pin = false },
    { name = "dotfiles-floating",     class = "dotfiles-floating",              size = "1000 700", pin = false },
    { name = "dotfiles-sidepad",      class = "dotfiles-sidepad",               size = "1000 700", pin = true },
    { name = "ml4w-welcome",          class = "com.ml4w.welcome",               size = "700 600",  pin = true },
}

for _, r in ipairs(center_floats) do
    hl.window_rule({
        name   = r.name,
        match  = { class = r.class },
        float  = true,
        center = true,
        pin    = r.pin,
        size   = r.size,
    })
end

-- 2. Fixed-Position ML4W UI Widgets
hl.window_rule({
    name   = "ml4w-calendar",
    match  = { class = "com.ml4w.calendar" },
    float  = true,
    pin    = true,
    move   = "21 76",
    size   = "400 400",
})

hl.window_rule({
    name   = "ml4w-sidebar",
    match  = { class = "com.ml4w.sidebar" },
    float  = true,
    pin    = true,
    move   = "monitor_w-window_w-21 76",
    size   = "400 660",
})

hl.window_rule({
    name   = "ml4w-settings",
    match  = { class = "com.ml4w.settings" },
    float  = true,
    pin    = true,
    move   = "monitor_w*0.5-window_w*0.5 86",
    size   = "800 600",
})

-- 3. Picture-in-Picture
hl.window_rule({
    name   = "picture-in-picture",
    match  = { title = [[^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$]] },
    float  = true,
    pin    = true,
    center = true,
})

-- 4. SwayNC Notification Center Blur & Opacity Layers
hl.layer_rule({
    name         = "swaync-control-center-blur",
    match        = { namespace = "swaync-control-center" },
    blur         = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name         = "swaync-notification-window-blur",
    match        = { namespace = "swaync-notification-window" },
    blur         = true,
    ignore_alpha = 0.5,
})
