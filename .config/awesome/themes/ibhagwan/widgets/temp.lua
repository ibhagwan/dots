--------------------------------------------------------------------------------
-- @File:   temp.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- cpu temperature widget
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-10-28 21:37:23
-- @Changes:
--      - added tempfile as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:36:28
-- @Changes:
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:57:37
-- @Changes:
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local os = os

local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local markup = lain.util.markup

local util = require("themes.ibhagwan.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}
local fa_temp_icons = {
    '', -- fa-battery-0 (alias) [&#xf2cb;]
    '', -- fa-battery-1 (alias) [&#xf2ca;]
    '', -- fa-battery-2 (alias) [&#xf2c9;]
    '', -- fa-battery-3 (alias) [&#xf2c8;]
}
-- [ function definitions ] ----------------------------------------------------
function get_temp_icon()
    local icon = {}
    if (coretemp_now < 62) then
        icon.icon = fa_temp_icons[1]
        icon.color = beautiful.widget_colors.temp
    elseif (coretemp_now > 70)then
        icon.icon = fa_temp_icons[4]
        icon.color = beautiful.fg_urgent
    else
        icon.icon = fa_temp_icons[3]
        icon.color = beautiful.widget_colors.temp
    end
    return icon
end
module.gen_wibar_widget = function(tempfile)
    local temp_icon = util.fa_ico(beautiful.widget_colors.temp, fa_temp_icons[1])
    local temp_widget = lain.widget.temp({
            timeout  = 5,
            tempfile = tempfile or nil,
            settings = function()
                icon = get_temp_icon()
                widget:set_markup(markup.fontfg(beautiful.font,
                                                icon.color,--beautiful.widget_colors.temp,
                                                coretemp_now .. "°C"))
                temp_icon:set_markup(util.fa_markup(icon.color, icon.icon))
            end
        })

    return util.create_wibar_widget(beautiful.widget_colors.temp, temp_icon,
                                    temp_widget)
end

-- [ return module objects ] ---------------------------------------------------
return module
