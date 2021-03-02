--------------------------------------------------------------------------------
-- @File:   battery.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- battery widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:31:41
-- @Changes:
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 09:43:15
-- @Changes:
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local os = os

local awful = require("awful")
local gears = require("gears")
local naughty  = require("naughty")
local gdebug = require("gears.debug")
local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local markup = lain.util.markup

local util = require("themes.ibhagwan.util")

-- [ local objects ] -----------------------------------------------------------
local widget = {}

local icons                 = {}
icons.icon_dir              = gears.filesystem.get_configuration_dir() .. "/icons"
icons.bat000charging        = icons.icon_dir .. "/bat-000-charging.png"
icons.bat000                = icons.icon_dir .. "/bat-000.png"
icons.bat020charging        = icons.icon_dir .. "/bat-020-charging.png"
icons.bat020                = icons.icon_dir .. "/bat-020.png"
icons.bat040charging        = icons.icon_dir .. "/bat-040-charging.png"
icons.bat040                = icons.icon_dir .. "/bat-040.png"
icons.bat060charging        = icons.icon_dir .. "/bat-060-charging.png"
icons.bat060                = icons.icon_dir .. "/bat-060.png"
icons.bat080charging        = icons.icon_dir .. "/bat-080-charging.png"
icons.bat080                = icons.icon_dir .. "/bat-080.png"
icons.bat100charging        = icons.icon_dir .. "/bat-100-charging.png"
icons.bat100                = icons.icon_dir .. "/bat-100.png"
icons.batcharged            = icons.icon_dir .. "/bat-charged.png"


local icons_alt             = {}
icons_alt.icon_dir          = gears.filesystem.get_configuration_dir() .. "/icons-alt-1"
icons_alt.batunknown        = icons_alt.icon_dir .. "/battery-unknown.svg"
icons_alt.bat000            = icons_alt.icon_dir .. "/battery-alert.svg"
icons_alt.bat020            = icons_alt.icon_dir .. "/battery-20.svg"
icons_alt.bat030            = icons_alt.icon_dir .. "/battery-30.svg"
icons_alt.bat050            = icons_alt.icon_dir .. "/battery-50.svg"
icons_alt.bat060            = icons_alt.icon_dir .. "/battery-60.svg"
icons_alt.bat080            = icons_alt.icon_dir .. "/battery-80.svg"
icons_alt.bat090            = icons_alt.icon_dir .. "/battery-90.svg"
icons_alt.bat100            = icons_alt.icon_dir .. "/battery-standard.svg"
icons_alt.bat000c           = icons_alt.icon_dir .. "/battery-charging-10.svg"
icons_alt.bat020c           = icons_alt.icon_dir .. "/battery-charging-20.svg"
icons_alt.bat030c           = icons_alt.icon_dir .. "/battery-charging-30.svg"
icons_alt.bat050c           = icons_alt.icon_dir .. "/battery-charging-50.svg"
icons_alt.bat060c           = icons_alt.icon_dir .. "/battery-charging-60.svg"
icons_alt.bat080c           = icons_alt.icon_dir .. "/battery-charging-80.svg"
icons_alt.bat090c           = icons_alt.icon_dir .. "/battery-charging-90.svg"
icons_alt.bat100c           = icons_alt.icon_dir .. "/battery-fully-charged.svg"

local bat_icons = {
    icons_alt.bat000,
    icons_alt.bat020,
    icons_alt.bat020,
    icons_alt.bat030,
    icons_alt.bat030,
    icons_alt.bat050,
    icons_alt.bat060,
    icons_alt.bat080,
    icons_alt.bat090,
    icons_alt.bat100,
}

local bat_icons_ac = {
    icons_alt.bat000c,
    icons_alt.bat020c,
    icons_alt.bat020c,
    icons_alt.bat030c,
    icons_alt.bat030c,
    icons_alt.bat050c,
    icons_alt.bat060c,
    icons_alt.bat080c,
    icons_alt.bat090c,
    icons_alt.bat100c,
}


local fa_bat_icons = {
    icons.bat000,
    icons.bat020,
    icons.bat040,
    icons.bat060,
    icons.bat080,
    icons.bat100,
}

local fa_bat_icons_ac = {
    icons.bat000charging,
    icons.bat020charging,
    icons.bat040charging,
    icons.bat060charging,
    icons.bat080charging,
    icons.batcharged,
}

local fa_bat_glyphs = {
    '', -- fa-battery-0 (alias) [&#xf244;]
    '', -- fa-battery-1 (alias) [&#xf243;]
    '', -- fa-battery-2 (alias) [&#xf242;]
    '', -- fa-battery-3 (alias) [&#xf241;]
    '' -- fa-battery-4 (alias) [&#xf240;]
}

local fa_bat_glyphs_ac = {
    '', -- fa-battery-0 (alias) [&#xf244;]
    '', -- fa-battery-1 (alias) [&#xf243;]
    '', -- fa-battery-2 (alias) [&#xf242;]
    '', -- fa-battery-3 (alias) [&#xf241;]
    ''  -- fa-battery-4 (alias) [&#xf240;]
    --''  -- fa-battery-4 (alias) [&#xf240;]
}

local fa_bat_glyphs_alt = {
    '', -- fa-battery-0 (alias) [&#xf579;]
    '', -- fa-battery-1 (alias) [&#xf57a;]
    '', -- fa-battery-2 (alias) [&#xf57b;]
    '', -- fa-battery-3 (alias) [&#xf57c;]
    '', -- fa-battery-3 (alias) [&#xf57d;]
    '', -- fa-battery-3 (alias) [&#xf57e;]
    '', -- fa-battery-3 (alias) [&#xf57f;]
    '', -- fa-battery-3 (alias) [&#xf580;]
    '', -- fa-battery-3 (alias) [&#xf581;]
    ''  -- fa-battery-4 (alias) [&#xf578;]
}

local fa_bat_glyphs_alt_ac = {
    '', -- fa-battery-0 (alias) [&#xf585;]
    '', -- fa-battery-0 (alias) [&#xf585;]
    '', -- fa-battery-2 (alias) [&#xf586;]
    '', -- fa-battery-2 (alias) [&#xf586;]
    '', -- fa-battery-3 (alias) [&#xf587;]
    '', -- fa-battery-3 (alias) [&#xf587;]
    '', -- fa-battery-3 (alias) [&#xf588;]
    '', -- fa-battery-3 (alias) [&#xf589;]
    '', -- fa-battery-3 (alias) [&#xf58a;]
    ''  -- fa-battery-4 (alias) [&#xf584;]
}

-- [ function definitions ] ----------------------------------------------------
local function batt_icon(use_icons)
    if (use_icons == 1) then
        local index = 1
        local perc = bat_now.perc
        if perc <= 7 then
            index = 1
        elseif perc <= 20 then
            index = 2
        elseif perc <= 40 then
            index = 3
        elseif perc <= 70 then
            index = 4
        elseif perc <= 90 then
            index = 5
        else
            index = 6
        end
        if bat_now.ac_status == 1 then
            return fa_bat_icons_ac[index]
        else
            return fa_bat_icons[index]
        end
    else
        local idx = math.floor(bat_now.perc / 10)
        if (use_icons == 2) then
            if bat_now.ac_status == 1 then
                return bat_icons_ac[idx]
            else
                return bat_icons[idx]
            end
        else
            if bat_now.ac_status == 1 then
                return fa_bat_glyphs_alt_ac[idx]
            else
                return fa_bat_glyphs_alt[idx]
            end
        end
    end
end

local function batt_text(bat_now)
    local ret = {}
    ret.title = string.format("Battery level: %d%%", bat_now.perc)

    ret.text = string.format("\n%s", bat_now.status)

    if (bat_now.ac_status == 1) and (bat_now.status == "Full") then
        ret.text = ret.text .. ", AC Connected"
    else
        ret.text = ret.text .. string.format("\nRemaining: %s", bat_now.time)
    end
    return ret
end

local function worker(args)

    local args = args or {}

    local use_icons = args.use_icons or 1
    local adapter   = args.adapter or nil
    local batteries = args.batteries or (args.battery and {args.battery}) or {}

    local notify_data = {
        title = "Battery status:"
    }
    local bat_icon = util.fa_ico(beautiful.widget_colors.bat, fa_bat_glyphs[1])
    if (use_icons == 1) then
        bat_icon = wibox.widget.imagebox(icons.bat000)
    elseif (use_icons == 2) then
        bat_icon = wibox.widget.imagebox(gears.surface.load_uncached(icons_alt.batunknown))
    end
    local bat_widget = lain.widget.bat({
        --timeout = 10,
        ac = adapter,
        batteries = batteries,
        settings = function()

            --gdebug.print_error(string.format("mouse::enter %s %s %d",
            --            bat_now.status, bat_now.ac_status, bat_now.perc))

            if (use_icons == 1) then
                bat_icon:set_image(batt_icon(use_icons))
            elseif (use_icons == 2) then
                bat_icon:set_image(gears.surface.load_uncached(batt_icon(use_icons)))
            else
                bat_icon:set_markup(
                    util.fa_markup(beautiful.widget_colors.bat,
                                   batt_icon(use_icons)))
            end

            local bat_text = batt_text(bat_now)
            notify_data.title = bat_text.title
            notify_data.text = bat_text.text
        end
    })

    local function notify(widget, timeout)
        bat_widget.update()
        if not widget.notification then
            widget.notification = naughty.notify {
                timeout = timeout,
                preset  = {
                    font = beautiful.notification_font or beautiful.font or "Monospace 9",
                    title = notify_data.title,
                    text = notify_data.text
                },
                destroy = function() widget.notification = nil end
            }
        else
            gdebug.print_error(string.format("mouse::enter replace text"))
            naughty.replace_text(widget.notification, preset.title, preset.text)
        end
    end

    bat_icon:connect_signal("mouse::enter", function()
        notify(widget, 0)
    end)
    bat_icon:connect_signal("mouse::leave", function()
        if not widget.notification then return end
        naughty.destroy(widget.notification)
        widget.notification = nil
    end)

    --bat_widget.update()
    --notify(bat_icon, 3)

    return wibox.widget{
        {
            -- add margins
            bat_icon,
            left = beautiful.icon_margin_left,
            right = beautiful.icon_margin_right,
            color = "#FF000000",
            widget = wibox.container.margin
        },
        --bat_icon,
        layout = wibox.layout.fixed.horizontal,
        expand = "none"
    }

    --return util.create_wibar_widget(beautiful.widget_colors.bat, bat_icon)
end


-- [ return module objects ] ---------------------------------------------------
return setmetatable(widget, { __call = function(_, ...) return worker(...) end })
