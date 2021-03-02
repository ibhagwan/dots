---------------------------
-- Default awesome theme --
---------------------------

local gears = require("gears")
local gdebug = require ("gears.debug")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Notification library
local naughty = require("naughty")


local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme         = require("themes.ibhagwan.theme_set")
local col_schemes   = require("themes.ibhagwan.col_schemes")
local wibox_widgets = require("themes.ibhagwan.widgets.wibox")

-- user config
local config = {
    -- default gap
    gap = 2,
    -- Your city for the weather forcast widget
    city_id = 5368361,
    -- Your color scheme
    color_scheme = "dark",
    -- Wallpaper
    wallpaper_path = nil
}
-- TODO verifying file exists doesn't work...
if gfs.file_readable(gfs.get_configuration_dir() .. "/config.lua") then
    config = require("config")
end

-- Set the color theme, dark is default
local color_scheme = {}
if (config.color_scheme == "xrdb") then color_scheme = col_schemes.xrdb()
elseif (config.color_scheme == "dark") then color_scheme = col_schemes.dark
elseif (config.color_scheme == "light") then color_scheme = col_schemes.light
elseif (config.color_scheme == "mirage") then color_scheme = col_schemes.mirage
else
    gdebug.print_warning("Invalid theme specified, will use 'light' theme")
    color_scheme = col_schemes.light
end

-- Set requested theme
theme:set_theme(color_scheme, config)

-- Dyanmically change the color theme
theme.set_dark = function(self) self:set_color_scheme(col_schemes.dark) end
theme.set_light = function(self) self:set_color_scheme(col_schemes.light) end
theme.set_mirage = function(self) self:set_color_scheme(col_schemes.mirage) end

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
--theme.icon_theme = nil
theme.icon_theme = config.icon_theme or "HighContrast"


-- Wallpaper
function theme.wallpaper(s)
    local wallpaper_path = config.wallpaper_path
    if (wallpaper_path ~= nil and wallpaper_path ~= '') then
        wallpaper_path = wallpaper_path:gsub("~", os.getenv("HOME"))
        awful.spawn(string.format('feh --bg-fill "%s"', wallpaper_path))
    end
end

-- no gaps for fullscreen mode
--[[tag.connect_signal("property::selected", function(t)
    t.gap = t.layout == awful.layout.suit.max.fullscreen and 0 or dpi(config.gap)
end)]]--
screen.connect_signal("arrange", function (s)
    t = s.selected_tag
    t.gap = t.layout == awful.layout.suit.max.fullscreen and 0 or dpi(config.gap)
end)

function theme.at_screen_connect(s)

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then wallpaper = wallpaper(s)
    else gears.wallpaper.maximized(wallpaper, s, true) end

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Start at tag #2
    local tag = s.tags[2]
    if tag then tag:view_only() end

    -- Set tag #1 as floating
    tag = s.tags[1]
    --if tag then tag.layout = awful.layout.layouts[ #awful.layout.layouts ] end
    if tag then tag.layout = awful.layout.suit.floating end

    -- Set tag #4 as fullscreen
    tag = s.tags[4]
    if tag then tag.layout = awful.layout.suit.max.fullscreen end


    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            wibox_widgets.mem(),
            wibox_widgets.cpu(),
            wibox_widgets.temp(config.tempfile),
            --wibox_widgets.fs(),
            wibox_widgets.kbd({
                font = theme.font,
                icon_font = theme.icon_font,
                fg_color = theme.fg_normal,
                bg_color = theme.bg_normal,
            }),
            wibox_widgets.weather(config.city_id, config.units, config.weather_icons),
            wibox_widgets.wifi({
                interface = "wlp3s0",
                use_icons = config.wifi_icons,
            }),
            wibox_widgets.vol({
                notification_preset = { font = theme.font, fg = theme.fg_normal },
                use_icons = config.volume_icons,
                bg_color = theme.fg_normal,
                main_color = theme.widget_colors.vol_main,
                mute_color = theme.widget_colors.vol_mute,
                width = 80,
                shape = 'rounded_bar',
                margins = 10,
            }),
            wibox_widgets.datetime(),
            wibox_widgets.bat({
                adapter = config.adapter,
                battery = config.battery,
                batteries = config.batteries,
                use_icons = config.bat_icons
            }),
        },
    }
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
