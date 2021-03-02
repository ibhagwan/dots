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


local fa_bat_icons = {
    icons.bat000,
    icons.bat020,
    icons.bat040,
    icons.bat060,
    icons.bat100,
}

local fa_bat_icons_ac = {
    icons.bat000charging,
    icons.bat020charging,
    icons.bat040charging,
    icons.bat060charging,
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
        local idx = math.floor(bat_now.perc / 25) + 1
        if bat_now.ac_status == 1 then
            return fa_bat_icons_ac[idx]
        else
            return fa_bat_icons[idx]
        end
    else
        local idx = math.floor(bat_now.perc / 10)
        if bat_now.ac_status == 1 then
            return fa_bat_glyphs_alt_ac[idx]
        else
            return fa_bat_glyphs_alt[idx]
        end
    end
end

local function batt_text(bat_now)
    if bat_now.status == "Full" then
        return string.format("%s%%\nAC Connected", bat_now.perc)
    else
        return string.format("\t%s%%\nRemaining: %s", bat_now.perc, bat_now.time)
    end
end

local function worker(args)

    local args = args or {}

    local use_icons = args.use_icons or 1

    local bat_icon = util.fa_ico(beautiful.widget_colors.bat, fa_bat_glyphs[1])
    if (use_icons == 1) then
        bat_icon = wibox.widget.imagebox(icons.bat000)
    end
    local bat_tooltip = awful.tooltip({
        objects = {},--{ bat_icon },
        margin_leftright = dpi(15),
        margin_topbottom = dpi(12),
        bg = bg_color,
        border_color = beautiful.border_normal,
    })
    bat_tooltip.wibox.fg = beautiful.fg_color
    bat_tooltip.textbox.font = beautiful.font
    bat_tooltip.timeout = 0
    bat_tooltip:set_shape(function(cr, width, height)
        gears.shape.infobubble(cr, width, height, corner_radius, arrow_size, width - dpi(20))
    end)
    local bat_widget = lain.widget.bat({
        settings = function()
            --[[
            local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or
                             bat_now.perc

            widget:set_markup(markup.fontfg(beautiful.font,
                                            beautiful.widget_colors.bat, perc))

            icon = batt_icon()
            bat_icon:set_markup(
                util.fa_markup(beautiful.widget_colors.bat, icon))
            --]]

            if (use_icons == 1) then
                bat_icon:set_image(batt_icon(use_icons))
            else
                bat_icon:set_markup(
                    util.fa_markup(beautiful.widget_colors.bat,
                                   batt_icon(use_icons)))
            end

            bat_tooltip:set_markup(markup.fontfg(beautiful.font,
                beautiful.fg_normal, batt_text(bat_now)))
        end
    })


    bat_icon:connect_signal("mouse::enter", function()
        --gdebug.print_error(string.format("mouse::enter %s %s", bat_tooltip.text, bat_tooltip.markup))
        if not widget.notification then
            local text
            local bat_widget = lain.widget.bat({
                notify = "off",
                full_notify = "off",
                settings = function()
                    --gdebug.print_error(string.format("mouse::enter %s %s %d",
                    --        bat_now.status, bat_now.ac_status, bat_now.perc))
                    text = batt_text(bat_now)
                end
            })
            widget.notification = naughty.notify {
                timeout = 0,
                preset  = {
                    font = beautiful.font or "Monospace 9",
                    title = "",
                    text = text
                },
                destroy = function() widget.notification = nil end
            }
        else
            gdebug.print_error(string.format("mouse::enter replace text"))
            naughty.replace_text(widget.notification, preset.title, preset.text)
        end
    end)
    bat_icon:connect_signal("mouse::leave", function()
        gdebug.print_error(string.format("mouse::leave %s", widget.notification))
        if not widget.notification then return end
        gdebug.print_error(string.format("destroyed notification %s", widget.notification))
        naughty.destroy(widget.notification)
        widget.notification = nil
    end)

    return util.create_wibar_widget(beautiful.widget_colors.bat, bat_icon)
end


-- [ return module objects ] ---------------------------------------------------
return setmetatable(widget, { __call = function(_, ...) return worker(...) end })
