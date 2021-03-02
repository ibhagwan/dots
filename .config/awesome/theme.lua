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

local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Initialize with the default theme
local theme = dofile(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Wallpaper
function theme.wallpaper(s)
    local filename = "EverestValley.jpg"
    awful.spawn(string.format("feh --bg-fill %s/Pictures/Wallpapers/%s", os.getenv("HOME"), filename))
end

-- no gaps for fullscreen mode
--[[tag.connect_signal("property::selected", function(t)
    t.gap = t.layout == awful.layout.suit.max.fullscreen and 0 or dpi(config.gap)
end)]]--
screen.connect_signal("arrange", function (s)
    t = s.selected_tag
    t.gap = t.layout == awful.layout.suit.max.fullscreen and 0 or dpi(2)
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
    local tag = s.tags[1]
    --if tag then tag.layout = awful.layout.layouts[ #awful.layout.layouts ] end
    if tag then tag.layout = awful.layout.suit.floating end

    -- Set tag #4 as fullscreen
    local tag = s.tags[4]
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
        },
    }
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
