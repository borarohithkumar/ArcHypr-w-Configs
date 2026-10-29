-- =============================================================================
-- AUTOSTART & SESSION DAEMONS
-- =============================================================================

local home         = os.getenv("HOME")
local scripts      = home .. "/.config/hypr/scripts"
local ml4w_scripts = home .. "/.config/ml4w/scripts"

-- Ensure cursor theme stays applied on every reload
hl.on("config.reloaded", function()
    hl.exec_cmd("hyprctl setcursor ArcStarry-cursors 24")
end)

hl.on("hyprland.start", function()
    -- 1. Portal & D-Bus environment synchronization
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- 2. Cursor Theme & Hyprpm plugins
    hl.exec_cmd("hyprctl setcursor ArcStarry-cursors 24")
    hl.exec_cmd("hyprpm reload -n")

    -- 3. Polkit Authentication Agent
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- 4. Session Daemons (Notifications, Idle Lock, Clipboard History)
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- 5. ML4W Integration & Wallpaper Restoration
    hl.exec_cmd(home .. "/.config/ml4w/listeners.sh --startall")
    hl.exec_cmd(scripts .. "/gtk.sh")
    hl.exec_cmd(scripts .. "/wallpaper-restore.sh")
    hl.exec_cmd(ml4w_scripts .. "/ml4w-autostart.sh")
    hl.exec_cmd(scripts .. "/cleanup.sh")
    hl.exec_cmd(home .. "/.config/com.ml4w.hyprlandsettings/hyprctl.sh")
end)
