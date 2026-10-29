-- =============================================================================
-- INPUT DEVICE CONFIGURATION (Keyboard, Pointer & Touchpad)
-- =============================================================================

hl.config({
    input = {
        kb_layout          = "us",
        kb_variant         = "",
        kb_model           = "",
        kb_options         = "",
        kb_rules           = "",
        numlock_by_default = true,

        follow_mouse       = 1,
        mouse_refocus      = false,
        sensitivity        = 0.1,

        touchpad = {
            natural_scroll       = true,
            scroll_factor        = 1.0,
            disable_while_typing = true,
        },
    },
})
