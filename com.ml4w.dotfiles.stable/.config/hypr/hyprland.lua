-- =============================================================================
-- HYPRLAND MAIN CONFIGURATION (Lua Engine)
-- =============================================================================
package.path = os.getenv("HOME") .. "/.config/hypr/lua/?.lua;" .. package.path

-- 1. Hardware, Environment & Displays
require("env")
require("monitors")
require("input")

-- 2. Styling, Colors & Animation Curves
require("appearance")
require("animations")

-- 3. Window & Layer Rules
require("rules")

-- 4. Keybindings & Shortcuts
require("keybindings")

-- 5. Daemon Listeners & Autostart
require("autostart")
