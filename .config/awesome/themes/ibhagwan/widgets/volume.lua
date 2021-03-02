-------------------------------------------------
-- Volume Bar Widget for Awesome Window Manager
-- Shows the current volume level
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volumebar-widget

-- @author Pavel Makhov
-- @copyright 2018 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local naughty  = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local gdebug = require("gears.debug")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local util = require("themes.ibhagwan.util")

local lain = require("lain")
local markup = lain.util.markup

--[[local GET_VOLUME_CMD = 'amixer -D pulse sget %s'
local INC_VOLUME_CMD = 'amixer -D pulse sset %s 5%%+'
local DEC_VOLUME_CMD = 'amixer -D pulse sset %s 5%%-'
local TOG_VOLUME_CMD = 'amixer -D pulse sset %s toggle']]--
local GET_VOLUME_CMD = "sh -c \'pactl list sinks | grep -A 15 \"Sink\"" ..
    "| grep \"^[[:space:]]Volume:\\|Mute:\" \'"
local INC_VOLUME_CMD = 'pactl list short sinks | cut -f1 |' ..
    'while read -r line; do pactl set-sink-volume $line +5%%; done'
local DEC_VOLUME_CMD  = 'pactl list short sinks | cut -f1 |' ..
    'while read -r line; do pactl set-sink-volume $line -5%%; done'
local TOG_VOLUME_CMD = 'pactl list short sinks | cut -f1 |' ..
    'while read -r line; do pactl set-sink-mute $line toggle; done'

local widget = {}

local icons              = {}
icons.icon_dir           = gears.filesystem.get_configuration_dir() .. "/icons"
icons.volmuted           = icons.icon_dir .. "/volume-muted-blocked.png"
icons.voloff             = icons.icon_dir .. "/volume-muted.png"
icons.vollow1            = icons.icon_dir .. "/volume-off.png"
icons.vollow2            = icons.icon_dir .. "/volume-low.png"
icons.volmed             = icons.icon_dir .. "/volume-medium.png"
icons.volhigh            = icons.icon_dir .. "/volume-high.png"

local fa_vol_icons = {
    icons.volmuted,
    icons.voloff,
    icons.vollow1,
    icons.vollow2,
    icons.volmed,
    icons.volhigh,
}

local fa_vol_glyphs = {
    --'婢',
    '',
    '', -- fa-volume-off [&#xf026;]
    '', -- fa-volume-off [&#xf026;]
    '', -- fa-volume-down [&#xf027;]
    '', -- fa-volume-down [&#xf027;]
    '', -- fa-volume-up [&#xf028;]
}

local function volume_icon(volume, mute, use_icons)
    local idx, perc = "", tonumber(volume) or 0
    if mute == "off" then
        idx = 1
    else
        if perc <= 5 then
            idx = 2
        elseif perc <= 15 then
            idx = 3
        elseif perc <= 40 then
            idx = 4
        elseif perc <= 70 then
            idx = 5
        else
            idx = 6
        end
    end
    if (use_icons == 1) then
        return fa_vol_icons[idx]
    else
        return fa_vol_glyphs[idx]
    end
end


local function worker(args)

    local args = args or {}

    local use_icons = args.use_icons or 1
    local main_color = args.main_color or beautiful.widget_colors.vol_main or beautiful.fg_normal
    local mute_color = args.mute_color or beautiful.widget_colors.vol_mute or beautiful.fg_urgent
    local bg_color = args.bg_color or beautiful.bg_color
    local width = args.width or 50
    local shape = args.shape or 'bar'
    local margins = args.margins or 10

    local ticks      = args.ticks or false
    local ticks_size = args.ticks_size or 7
    local tick       = args.tick or "|"
    local tick_pre   = args.tick_pre or "["
    local tick_post  = args.tick_post or "]"
    local tick_none  = args.tick_none or " "

    local channel        = args.channel or "Master"
    local get_volume_cmd = args.get_volume_cmd or string.format(GET_VOLUME_CMD, channel)
    local inc_volume_cmd = args.inc_volume_cmd or string.format(INC_VOLUME_CMD, channel)
    local dec_volume_cmd = args.dec_volume_cmd or string.format(DEC_VOLUME_CMD, channel)
    local tog_volume_cmd = args.tog_volume_cmd or string.format(TOG_VOLUME_CMD, channel)

    local notification_preset = args.notification_preset
    if not notification_preset then
        notification_preset = { font = beautiful.font or "Monospace 9" }
    end

    local vol_icon = wibox.widget.textbox(fa_vol_glyphs[1])
    if (use_icons == 1) then
        vol_icon = wibox.widget.imagebox(fa_vol_icons[1])
    end

    local volumebar_widget = wibox.widget {
        max_value = 1,
        forced_width = width,
        color = main_color,
        background_color = bg_color,
        shape = gears.shape[shape],
        margins = {
            top = margins,
            bottom = margins,
        },
        widget = wibox.widget.progressbar
    }

    local vol_widget = wibox.widget{
        {
            -- add margins
            vol_icon,
            left = beautiful.icon_margin_left,
            right = beautiful.icon_margin_right,
            color = "#FF000000",
            widget = wibox.container.margin
        },
        volumebar_widget,
        layout = wibox.layout.fixed.horizontal,
        expand = "none"
    }

    local vol_from_stdout = function(stdout)
        local volume = string.match(stdout, "(%d?%d?%d)%%")  -- (\d?\d?\d)\%)
        --gdebug.print_error(string.format("stdout:\n%s\tvolume: '%s'", stdout, volume))
        volume = tonumber(string.format("% 3d", volume))
        return volume
    end

    local mute_from_stdout = function(stdout)
        local mute = string.match(stdout, "%[(o%D%D?)%]")    -- \[(o\D\D?)\] - [on] or [off]
        return mute
    end

    local mute_from_stdout_pacmd = function(stdout)
        local mute = string.match(stdout, "Mute:%s(%a+)")   -- \Mute:\D? - yes or no
        if mute == "yes" then mute = "off" end
        --gdebug.print_error(string.format("stdout:\n%s\tmute: '%s'", stdout, mute))
        return mute
    end

    local update_graphic = function(args, stdout, _, _, _)
        local mute = mute_from_stdout_pacmd(stdout)
        local volume = vol_from_stdout(stdout)

        local notify = args.notify or 0
        local icon = args.icon
        local widget = args.widget
        local use_icons = args.use_icons or 1

        widget.value = volume / 100;
        widget.color = mute == "off"
                and mute_color
                or main_color

        if (use_icons == 1) then
            icon:set_image(volume_icon(volume, mute, use_icons))
        else
            icon:set_markup(
                util.fa_markup(beautiful.widget_colors.volume,
                               volume_icon(volume, mute, use_icons)))
        end

        --gdebug.print_error(string.format("1: vol %d %s", volume, mute))
    end

    local notify = function(args, stdout, _, _, _)
        local mute = mute_from_stdout_pacmd(stdout)
        local volume = vol_from_stdout(stdout)

        local icon = args.icon
        local widget = args.widget
        local use_icons = args.use_icons or 1

        --gdebug.print_error(string.format("2: vol %d %s", volume, mute))

        local preset = notification_preset

        preset.title = string.format("%s - %s%%", 'Master', volume)

        if mute == "off" then
            preset.title = preset.title .. " Muted"
        end

        -- tot is the maximum number of ticks to display in the notification
        --local tot = alsabar.notification_preset.max_ticks
        local tot = nil

        if not tot then
            local wib = awful.screen.focused().mywibox
            -- if we can grab mywibox, tot is defined as its height if
            -- horizontal, or width otherwise
            if wib then
                if wib.position == "left" or wib.position == "right" then
                    tot = wib.width
                else
                    tot = wib.height
                end
            -- fallback: default horizontal wibox height
            else
                tot = 20
            end
        end

        int = math.modf((volume / 100) * tot)
        preset.text = markup.font(beautiful.notification_font or beautiful.font,
                string.format(
                "%s%s%s%s",
                tick_pre,
                string.rep(tick, int),
                string.rep(tick_none, tot - int),
                tick_post
        ))

        if not widget.notification then
            widget.notification = naughty.notify {
                preset  = preset,
                destroy = function() widget.notification = nil end
            }
        else
            naughty.replace_text(widget.notification, preset.title, preset.text)
        end
    end

    vol_widget:connect_signal("button::press", function(_, _, _, button)
        if (button == 5) then
            os.execute(inc_volume_cmd)
            --awful.spawn(inc_volume_cmd)
        elseif (button == 4) then
            os.execute(dec_volume_cmd)
            --awful.spawn(dec_volume_cmd)
        elseif (button == 1) then
            os.execute(tog_volume_cmd)
            --awful.spawn(tog_volume_cmd)
        end

        local args = {
            icon =  vol_icon,
            widget = volumebar_widget,
            use_icons = use_icons,
            notify = 1
        }

        spawn.easy_async(get_volume_cmd, function(stdout, stderr, exitreason, exitcode)
            update_graphic(args, stdout, stderr, exitreason, exitcode)
            notify(args, stdout, stderr, exitreason, exitcode)
        end)
    end)

    watch(get_volume_cmd, 5, update_graphic,
        { widget = volumebar_widget, icon =  vol_icon, use_icons = use_icons } )

    return vol_widget

end

return setmetatable(widget, { __call = function(_, ...) return worker(...) end })

