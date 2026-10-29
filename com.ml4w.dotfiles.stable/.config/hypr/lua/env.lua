-- =============================================================================
-- ENVIRONMENT VARIABLES & XWAYLAND
-- =============================================================================

-- 1. Desktop Session & Wayland Core
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- 2. Toolkit Integrations (Qt, GTK, Electron, SDL, Mozilla)
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("GDK_SCALE", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")

-- 3. Cursor Theme & Size
hl.env("XCURSOR_THEME", "ArcStarry-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "ArcStarry-cursors")
hl.env("HYPRCURSOR_SIZE", "24")

-- 4. XWayland Zero-Scaling
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
