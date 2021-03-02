--------------------------------------------------------------------------------
-- @File:   wibox.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-07-15 08:12:41
-- [ description ] -------------------------------------------------------------
-- wibar widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:51:52
-- @Changes:
--      - added header
--------------------------------------------------------------------------------
local os = os

local gears = require("gears")
local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local markup = lain.util.markup

local util = require("themes.ibhagwan.util")

-- widgets
local date_time = require("themes.ibhagwan.widgets.date_time")
local weather   = require("themes.ibhagwan.widgets.weather")
local cpu       = require("themes.ibhagwan.widgets.cpu")
local temp      = require("themes.ibhagwan.widgets.temp")
local battery   = require("themes.ibhagwan.widgets.battery")
local memory    = require("themes.ibhagwan.widgets.memory")
local volume    = require("themes.ibhagwan.widgets.volume")
local wifi      = require("themes.ibhagwan.widgets.wifi")
--local wifi      = require("themes.ibhagwan.widgets.wifi-alt")
local kbd       = require("themes.ibhagwan.widgets.kbdlayout")

--local alsa    = require("themes.ibhagwan.widgets.alsa")
--local net     = require("themes.ibhagwan.widgets.net")
--local fs      = require("themes.ibhagwan.widgets.fs")
--local mpd     = require("themes.ibhagwan.widgets.mpd")


local module = {
    datetime    = date_time.gen_wibar_widget,
    weather     = weather.gen_wibar_widget,
    mem         = memory.gen_wibar_widget,
    cpu         = cpu.gen_wibar_widget,
    temp        = temp.gen_wibar_widget,
    --bat         = battery.gen_wibar_widget,
    bat         = battery,
    kbd         = kbd,
    wifi        = wifi,
    vol         = volume,
    --vol       = alsa.gen_wibar_widget,
    --net       = net.gen_wibar_widget,
    --fs        = fs.gen_wibar_widget,
    --mpd       = mpd.gen_wibar_widget,
}

return module
