-- =============================================================================
-- APPEARANCE, LAYOUTS & MISC CONFIGURATION
-- =============================================================================

local colors = require("colors")

hl.config({
    general = {
        gaps_in          = 6,
        gaps_out         = 7,
        border_size      = 1,
        layout           = "dwindle",
        resize_on_border = true,
        col = {
            active_border   = { colors = { colors.primary, colors.on_primary }, angle = 90 },
            inactive_border = colors.on_primary,
        },
    },

    decoration = {
        rounding           = 10,
        active_opacity     = 1.0,
        inactive_opacity   = 0.9,
        fullscreen_opacity = 1.0,

        blur = {
            enabled           = true,
            size              = 4,
            passes            = 4,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = true,
        },

        shadow = {
            enabled      = true,
            range        = 32,
            render_power = 2,
            color        = colors.shadow_soft,
        },
    },

    dwindle = {
        preserve_split = true,
    },

    binds = {
        workspace_back_and_forth = false,
        allow_workspace_cycles   = true,
        pass_mouse_when_bound    = false,
    },

    misc = {
        disable_hyprland_logo      = true,
        disable_splash_rendering   = true,
        initial_workspace_tracking = 1,
        on_focus_under_fullscreen  = 1,
        allow_session_lock_restore = true,
    },
})
