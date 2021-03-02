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

local dpi = require("beautiful.xresources").apply_dpi

local util = require("themes.ibhagwan.util")

local lain = require("lain")
local markup = lain.util.markup


local widget = {}

local icons              = {}
icons.icon_dir           = gears.filesystem.get_configuration_dir() .. "/icons"
icons.wifidisc           = icons.icon_dir .. "/wireless-disconnected.png"
icons.wififull           = icons.icon_dir .. "/wireless-full.png"
icons.wifihigh           = icons.icon_dir .. "/wireless-high.png"
icons.wifilow            = icons.icon_dir .. "/wireless-low.png"
icons.wifimed            = icons.icon_dir .. "/wireless-medium.png"
icons.wifinone           = icons.icon_dir .. "/wireless-none.png"

local icons_alt          = {}
icons_alt.icon_dir       = gears.filesystem.get_configuration_dir() .. "/icons-alt-1"
icons_alt.wifidisc       = icons_alt.icon_dir .. "/wifi-off.svg"
icons_alt.wifinone       = icons_alt.icon_dir .. "/wifi-strength-empty.svg"
icons_alt.wifilow        = icons_alt.icon_dir .. "/wifi-strength-1.svg"
icons_alt.wifimed        = icons_alt.icon_dir .. "/wifi-strength-2.svg"
icons_alt.wifihigh       = icons_alt.icon_dir .. "/wifi-strength-3.svg"
icons_alt.wififull       = icons_alt.icon_dir .. "/wifi-strength-4.svg"
icons_alt.wifi           = icons_alt.icon_dir .. "/wifi.svg"

local wifi_icons = {
    icons_alt.wifidisc,
    icons_alt.wifinone,
    icons_alt.wifilow,
    icons_alt.wifimed,
    icons_alt.wifihigh,
    icons_alt.wififull,
}

local fa_wifi_icons = {
    icons.wifidisc,
    icons.wifinone,
    icons.wifilow,
    icons.wifimed,
    icons.wifihigh,
    icons.wififull,
}

local fa_wifi_glyphs = {
    '睊', -- fa-wifi [&xfaa9;]
    '直', -- fa-wifi [&xfaa8;]
    '直', -- fa-wifi [&xfaa8;]
    '直', -- fa-wifi [&xfaa8;]
    '直', -- fa-wifi [&xfaa8;]
    '直', -- fa-wifi [&xfaa8;]
    --'', -- fa-wifi [&xf1eb;]
}

local function set_wifi_icon(icon, index, use_icons)
    if (use_icons==1) then
        icon:set_image(fa_wifi_icons[index])
    elseif (use_icons==2) then
        icon:set_image(gears.surface.load_uncached(wifi_icons[index]))
    else
        icon:set_markup(
            util.fa_markup(beautiful.widget_colors.wifi,
                          fa_wifi_glyphs[index]))
    end
end

local function worker(args)

    local args = args or {}
    local font = args.font or beautiful.font
    local icon_font = args.icon_font or beautiful.icon_font or beautiful.font
    local fg_color = args.fg_color or beautiful.fg_normal
    local bg_color = args.bg_color or beautiful.bg_normal
    local interface = args.interface or "wlan0"

    local use_icons = args.use_icons or 1

    local notify_data = {
        title = "iw dev " .. interface .. " link"
    }
    local wifi_icon = wibox.widget.textbox(fa_wifi_glyphs[1])
    if (use_icons == 1) then
        wifi_icon = wibox.widget.imagebox(fa_wifi_icons[1])
    elseif (use_icons == 2) then
        wifi_icon = wibox.widget.imagebox(gears.surface.load_uncached(wifi_icons[1]))
    end

    local wifi_tooltip = awful.tooltip({
        objects = { wifi_icon },
        margin_leftright = dpi(15),
        margin_topbottom = dpi(15),
        bg = bg_color,
        border_color = fg_color,
    })
    wifi_tooltip.wibox.fg = fg_color
    -- DO NOT SET bg_color, will mess up the tooltip shape
    --wifi_tooltip.wibox.bg = bg_color
    wifi_tooltip.textbox.font = font
    wifi_tooltip.timeout = 0
    wifi_tooltip:set_shape(function(cr, width, height)
        gears.shape.infobubble(cr, width, height, corner_radius, arrow_size, width - dpi(120))
    end)
    local mywifisig = awful.widget.watch(
        { awful.util.shell, "-c",
            "awk 'NR==3 {printf(\"%d-%.0f\\n\",$2, $3*10/7)}' /proc/net/wireless; iw dev "
            .. interface .. " link" },
        2,
        function(widget, stdout)
            local carrier, perc = stdout:match("(%d)-(%d+)")
            notify_data.text = stdout:gsub("(%d)-(%d+)", ""):gsub("%s+$", "")
            wifi_tooltip:set_markup(markup.font(
                    beautiful.notification_font or beautiful.font,
                    notify_data.text))

            perc = tonumber(perc)

            if carrier == "1" or not perc then
                set_wifi_icon(wifi_icon, 1, use_icons)
                wifi_tooltip:set_markup("No carrier")
            else
                if perc <= 5 then
                    set_wifi_icon(wifi_icon, 2, use_icons)
                elseif perc <= 25 then
                    set_wifi_icon(wifi_icon, 3, use_icons)
                elseif perc <= 50 then
                    set_wifi_icon(wifi_icon, 4, use_icons)
                elseif perc <= 75 then
                    set_wifi_icon(wifi_icon, 5, use_icons)
                else
                    set_wifi_icon(wifi_icon, 6, use_icons)
                end
            end
        end
    )
    wifi_icon:connect_signal("button::press", function()
        awful.spawn(string.format("%s -e wavemon", awful.util.terminal))
    end)

    --[[wifi_icon:connect_signal("mouse::enter", function()
        if not widget.notification then
            widget.notification = naughty.notify {
                timeout = timeout,
                preset  = {
                    font = beautiful.font or "Monospace 9",
                    title = notify_data.title,
                    text = notify_data.text
                },
                destroy = function() widget.notification = nil end
            }
        else
            gdebug.print_error(string.format("mouse::enter replace text"))
            naughty.replace_text(widget.notification, preset.title, preset.text)
        end
    end)
    wifi_icon:connect_signal("mouse::leave", function()
        if not widget.notification then return end
        naughty.destroy(widget.notification)
        widget.notification = nil
    end)]]--

    return wibox.widget{
        {
            -- add margins
            wifi_icon,
            left = beautiful.icon_margin_left,
            right = beautiful.icon_margin_right,
            color = "#FF000000",
            widget = wibox.container.margin
        },
        --wifi_icon,
        layout = wibox.layout.fixed.horizontal,
        expand = "none"
    }
end

return setmetatable(widget, { __call = function(_, ...) return worker(...) end })

