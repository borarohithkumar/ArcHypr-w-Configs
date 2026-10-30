-- =============================================================================
-- KEYBINDINGS CONFIGURATION (Hyprland 0.57 Lua API)
-- =============================================================================

local mainMod      = "SUPER"
local home         = os.getenv("HOME")
local hypr_scripts = home .. "/.config/hypr/scripts"
local ml4w_scripts = home .. "/.config/ml4w/scripts"
local ml4w_set     = home .. "/.config/ml4w/settings"

-- -----------------------------------------------------------------------------
-- 1. Applications & Core Launchers
-- -----------------------------------------------------------------------------
hl.bind(mainMod .. " + RETURN",   hl.dsp.exec_cmd(ml4w_set .. "/terminal.sh"))
hl.bind(mainMod .. " + B",        hl.dsp.exec_cmd(ml4w_set .. "/browser.sh"))
hl.bind(mainMod .. " + E",        hl.dsp.exec_cmd(ml4w_set .. "/filemanager.sh"))
hl.bind(mainMod .. " + period",   hl.dsp.exec_cmd(ml4w_set .. "/emojipicker.sh"))
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd(ml4w_set .. "/calculator.sh"))
hl.bind(mainMod .. " + SUPER_L",  hl.dsp.exec_cmd(hypr_scripts .. "/launcher.sh"), { release = true })

-- -----------------------------------------------------------------------------
-- 2. Window Management & Tiling Controls
-- -----------------------------------------------------------------------------
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"))
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + M",         hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + T",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + T", function() local ws = hl.get_active_workspace(); if ws then for _, w in ipairs(ws:get_windows()) do hl.dispatch(hl.dsp.window.float({ window = w, action = "toggle" })) end end end)
hl.bind(mainMod .. " + J",         hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + K",         hl.dsp.layout("swapsplit"))
hl.bind(mainMod .. " + G",         hl.dsp.group.toggle())

-- Focus navigation
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Swap tiled windows
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.swap({ direction = "down" }))

-- Window cycling
hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end, { repeating = true })

-- Keyboard resizing
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0, y = -100, relative = true }))

-- Mouse window dragging and resizing
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { drag = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { drag = true })

-- Display Zoom
hl.bind(mainMod .. " + SHIFT + mouse_down", function()
    local cur = hl.get_config("cursor.zoom_factor") or 1.0
    hl.config({ cursor = { zoom_factor = cur + 0.5 } })
end)
hl.bind(mainMod .. " + SHIFT + mouse_up", function()
    local cur = hl.get_config("cursor.zoom_factor") or 1.0
    hl.config({ cursor = { zoom_factor = math.max(1.0, cur - 0.5) } })
end)
hl.bind(mainMod .. " + SHIFT + Z", function()
    hl.config({ cursor = { zoom_factor = 1.0 } })
end)

-- -----------------------------------------------------------------------------
-- 3. System Utilities & ML4W Actions
-- -----------------------------------------------------------------------------
hl.bind(mainMod .. " + CTRL + R",  hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(hypr_scripts .. "/toggle-animations.sh"))
hl.bind(mainMod .. " + ALT + A",   hl.dsp.exec_cmd(hypr_scripts .. "/text-extractor.sh"))
hl.bind(mainMod .. " + CTRL + Q",  hl.dsp.exec_cmd(ml4w_scripts .. "/wlogout.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(hypr_scripts .. "/waypaper.sh --random"))
hl.bind(mainMod .. " + CTRL + W",  hl.dsp.exec_cmd(hypr_scripts .. "/waypaper.sh"))
hl.bind(mainMod .. " + ALT + W",   hl.dsp.exec_cmd(hypr_scripts .. "/wallpaper-automation.sh"))
hl.bind(mainMod .. " + CTRL + K",  hl.dsp.exec_cmd(hypr_scripts .. "/keybindings.sh"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(home .. "/.config/waybar/launch.sh"))
hl.bind(mainMod .. " + CTRL + B",  hl.dsp.exec_cmd(home .. "/.config/waybar/toggle.sh"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(hypr_scripts .. "/loadconfig.sh"))
hl.bind(mainMod .. " + V",         hl.dsp.exec_cmd(ml4w_scripts .. "/cliphist.sh"))
hl.bind(mainMod .. " + CTRL + T",  hl.dsp.exec_cmd(home .. "/.config/waybar/themeswitcher.sh"))
hl.bind(mainMod .. " + CTRL + S",  hl.dsp.exec_cmd("flatpak run com.ml4w.settings"))
hl.bind(mainMod .. " + ALT + G",   hl.dsp.exec_cmd(hypr_scripts .. "/gamemode.sh"))
hl.bind(mainMod .. " + CTRL + L",  hl.dsp.exec_cmd(hypr_scripts .. "/power.sh lock"))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.exec_cmd(hypr_scripts .. "/hyprshade.sh"))
hl.bind("CTRL + Tab",              hl.dsp.exec_cmd(ml4w_scripts .. "/focus.sh"))
hl.bind("CTRL + ALT + T",          hl.dsp.exec_cmd(home .. "/.config/ml4w/themes/themes.sh"))

-- Screenshots & Recording
hl.bind("PRINT",                hl.dsp.exec_cmd(hypr_scripts .. "/screenshot.sh"))
hl.bind(mainMod .. " + PRINT",  hl.dsp.exec_cmd(hypr_scripts .. "/screenshot.sh --instant"))
hl.bind("ALT + PRINT",          hl.dsp.exec_cmd(hypr_scripts .. "/screenshot.sh --instant-area"))
hl.bind("SHIFT + PRINT",        hl.dsp.exec_cmd(hypr_scripts .. "/record_screen.sh"))

-- Sidepad Integration
hl.bind(mainMod .. " + CTRL + right", hl.dsp.exec_cmd(ml4w_scripts .. "/sidepad.sh"))
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.exec_cmd(ml4w_scripts .. "/sidepad.sh --hide"))
hl.bind(mainMod .. " + S",            hl.dsp.exec_cmd(ml4w_scripts .. "/sidepad.sh --init"))
hl.bind(mainMod .. " + SHIFT + S",    hl.dsp.exec_cmd(ml4w_scripts .. "/sidepad.sh --select"))

-- -----------------------------------------------------------------------------
-- 4. Workspace Management
-- -----------------------------------------------------------------------------
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key, function() local ws = hl.get_active_workspace(); if ws then for _, w in ipairs(ws:get_windows()) do hl.dispatch(hl.dsp.window.move({ window = w, workspace = i, silent = true })) end end; hl.dispatch(hl.dsp.focus({ workspace = i })) end)
end

hl.bind(mainMod .. " + Tab",         hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + mouse_down",  hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",    hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.focus({ workspace = "empty" }))

-- -----------------------------------------------------------------------------
-- 5. Hardware & Multimedia Keys (Fn Keys)
-- -----------------------------------------------------------------------------
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -q s +1%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 1%-"))
hl.bind("code:238",              hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s +10"))
hl.bind("code:237",              hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10-"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"))

hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"))
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"))

hl.bind("XF86Calculator",  hl.dsp.exec_cmd(ml4w_set .. "/calculator.sh"))
hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("XF86Tools",       hl.dsp.exec_cmd("flatpak run com.ml4w.settings"))

-- -----------------------------------------------------------------------------
-- 6. Win+X Nested Submap System (Safely Scoped via hl.define_submap)
-- -----------------------------------------------------------------------------
hl.bind(mainMod .. " + X", function()
    hl.exec_cmd('notify-send -u low -t 2500 "X Mode" "A=TTY | U=Power Mode | Esc=Exit"')
    hl.dispatch(hl.dsp.submap("win_x_main"))
end)

hl.define_submap("win_x_main", function()
    hl.bind("a", function()
        hl.exec_cmd('notify-send -t 1500 "System" "Launching TTY..."')
        hl.exec_cmd(ml4w_set .. "/terminal.sh")
        hl.dispatch(hl.dsp.submap("reset"))
    end)

    hl.bind("u", function()
        hl.exec_cmd('notify-send -u normal -t 4000 "Power Mode" "L=Lock | S=Suspend | R=Reboot(10s) | U=Shutdown(10s) | C=Cancel"')
        hl.dispatch(hl.dsp.submap("power_menu"))
    end)

    hl.bind("escape", function()
        hl.exec_cmd('notify-send -t 1500 "X Mode" "Exited"')
        hl.dispatch(hl.dsp.submap("reset"))
    end)
end)

hl.define_submap("power_menu", function()
    hl.bind("u", function()
        hl.exec_cmd('notify-send -u critical "System" "Shutting in 10secs... (Re-enter to Cancel)"')
        hl.exec_cmd("sleep 10 && systemctl poweroff")
        hl.dispatch(hl.dsp.submap("reset"))
    end)

    hl.bind("r", function()
        hl.exec_cmd('notify-send -u critical "System" "Rebooting in 10secs... (Re-enter to Cancel)"')
        hl.exec_cmd("sleep 10 && systemctl reboot")
        hl.dispatch(hl.dsp.submap("reset"))
    end)

    hl.bind("s", function()
        hl.exec_cmd('notify-send "System" "Suspending..."')
        hl.exec_cmd("systemctl suspend")
        hl.dispatch(hl.dsp.submap("reset"))
    end)

    hl.bind("l", function()
        hl.exec_cmd('notify-send "System" "Locking..."')
        hl.exec_cmd("hyprlock")
        hl.dispatch(hl.dsp.submap("reset"))
    end)

    hl.bind("c", function()
        hl.exec_cmd("pkill sleep")
        hl.exec_cmd('notify-send -u normal "System" "Shutdown/Reboot CANCELLED"')
        hl.dispatch(hl.dsp.submap("reset"))
    end)

    hl.bind("escape", function()
        hl.exec_cmd('notify-send -t 1500 "Power Mode" "Exited"')
        hl.dispatch(hl.dsp.submap("reset"))
    end)
end)
