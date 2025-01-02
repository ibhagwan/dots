local wezterm = require "wezterm"
local config = wezterm.config_builder()
local act = wezterm.action
config.font = wezterm.font "Monospace"
config.font_size = 7.0
-- https://github.com/wez/wezterm/issues/3774
config.front_end = "OpenGL"
config.freetype_load_flags = "NO_HINTING"
-- config.freetype_load_target = "Light"
-- config.freetype_render_target = "HorizontalLcd"
-- Match Alacritty / Kitty default behavior
config.bold_brightens_ansi_colors = false
-- Overrides "cursor_{fg|bg|border}"
-- https://wezfurlong.org/wezterm/config/lua/config/force_reverse_video_cursor.html?h=force_reverse_video_cursor
config.force_reverse_video_cursor = true
config.colors = {
  background = "#1b2738",
  foreground = "#a6b2c0",
  selection_bg = "#273951",
  selection_fg = "#d3dbe5",
  cursor_fg = "black",
  cursor_bg = "#ddb3ff",
  cursor_border = "#ddb3ff",
  ansi = {
    "#011627", -- black
    "#ff9999", -- red
    "#85cc95", -- green
    "#ffd700", -- yellow
    "#7fb5ff", -- blue
    "#ddb3ff", -- magenta
    "#21c7a8", -- cyan
    "#ffffff", -- white
  },
  brights = {
    "#575656", -- black
    "#ff9999", -- red
    "#85cc95", -- green
    "#ffd700", -- yellow
    "#7fb5ff", -- blue
    "#ddb3ff", -- magenta
    "#85cc95", -- cyan
    "#ffffff", -- white
  }
}
config.initial_rows = 39
config.initial_cols = 126
config.enable_tab_bar = false
config.enable_scroll_bar = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.keys = {
  { key = "s", mods = "CMD",  action = wezterm.action.PasteFrom "PrimarySelection" },
  { key = "/", mods = "CTRL", action = wezterm.action { SendString = "\x1f" } },
}
local function mouse_bind(direction, streak, button, mods, action)
  return {
    event = { [direction] = { streak = streak, button = button } },
    mods = mods,
    action = action,
  }
end
-- https://wezfurlong.org/wezterm/config/mouse.html
config.disable_default_mouse_bindings = false
config.mouse_bindings = {
  -- Do not override the clipboard when selecting using the mouse
  mouse_bind("Up", 1, "Left", "NONE", act.CompleteSelectionOrOpenLinkAtMouseCursor "PrimarySelection"),
  mouse_bind("Up", 2, "Left", "NONE", act.CompleteSelection "PrimarySelection"),
  mouse_bind("Up", 3, "Left", "NONE", act.CompleteSelection "PrimarySelection"),
  mouse_bind("Up", 1, "Left", "SHIFT",
    act.CompleteSelectionOrOpenLinkAtMouseCursor "PrimarySelection"),
  mouse_bind("Up", 1, "Left", "ALT", act.CompleteSelection "PrimarySelection"),
  mouse_bind("Up", 1, "Left", "SHIFT|ALT",
    act.CompleteSelectionOrOpenLinkAtMouseCursor "PrimarySelection"),
}
return config
