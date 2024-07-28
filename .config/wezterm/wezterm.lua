local wezterm = require "wezterm"
local config = wezterm.config_builder()
local act = wezterm.action
config.font = wezterm.font "Monospace"
config.font_size = 7.0
-- Match Alacritty / Kitty default behavior
config.bold_brightens_ansi_colors = false
-- Overrides "cursor_{fg|bg|border}"
-- https://wezfurlong.org/wezterm/config/lua/config/force_reverse_video_cursor.html?h=force_reverse_video_cursor
config.force_reverse_video_cursor = true
config.colors = {
  background = "#323F4E",
  foreground = "#F8F8F2",
  selection_bg = "#3D4C5F",
  selection_fg = "#BD99FF",
  cursor_fg = "black",
  cursor_bg = "#FFB573",
  cursor_border = "#FFB573",
  ansi = {
    "#3D4C5F", -- black
    "#F48FB1", -- red
    "#A1EFD3", -- green
    "#FFFED5", -- yellow
    "#92B6F4", -- blue
    "#FFB2FF", -- magenta
    "#87DFEB", -- cyan
    "#F1F1F2", -- white
  },
  brights = {
    "#56687E", -- black
    "#EE4F84", -- red
    "#53E2AE", -- green
    "#FFFDC2", -- yellow
    "#6498EF", -- blue
    "#FF8FFD", -- magenta
    "#24D1E7", -- cyan
    "#FFFFFF", -- white
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
  { key = 's', mods = 'CMD',  action = wezterm.action.PasteFrom "PrimarySelection" },
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
  mouse_bind("Up", 1, "Left", "SHIFT", act.CompleteSelectionOrOpenLinkAtMouseCursor "PrimarySelection"),
  mouse_bind("Up", 1, "Left", "ALT", act.CompleteSelection "PrimarySelection"),
  mouse_bind("Up", 1, "Left", "SHIFT|ALT", act.CompleteSelectionOrOpenLinkAtMouseCursor "PrimarySelection"),
}
return config
