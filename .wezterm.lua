local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "GitHub Dark"
config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font("CommitMono Nerd Font Mono")
config.font_size = 18

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

-- config.window_background_opacity = 0.85
-- config.macos_window_background_blur = 20

-- and finally, return the configuration to wezterm
return config
