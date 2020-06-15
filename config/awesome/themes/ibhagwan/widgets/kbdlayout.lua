local awful = require("awful")
local gears = require("gears")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gdebug = require ("gears.debug")

local lain = require("lain")
local markup = lain.util.markup

local util = require("themes.ibhagwan.util")

-- requires `xkb-switch`
-- https://github.com/grwlf/xkb-switch
local TOG_LAYOUT_CMD = "xkb-switch -n"

local function worker(args)

    local args = args or {}

    local kbd_icon = args.icon or ""
    local font = args.font or beautiful.font
    local icon_font = args.icon_font or beautiful.icon_font or beautiful.font

    local tog_layout_cmd = args.tog_layout_cmd or TOG_LAYOUT_CMD

    local kbd_widget = wibox.widget.textbox ()

    local update_layout = function(widget, stdout, _, _, _)
        local layouts_raw = awful.widget.keyboardlayout.get_groups_from_group_names(
            awesome.xkb_get_group_names())
        local cur_layout = awesome.xkb_get_layout_group()
        if layouts_raw == nil or layouts_raw[1] == nil then
            gdebug.print_error("Failed to get list of keyboard groups")
            return
        end
        local layouts = {}
        if #layouts_raw == 1 then
            layouts[1] = layouts_raw[1].file
        end
        for _, v in ipairs(layouts_raw) do
            layouts[v.group_idx] = v.file
        end
        widget.markup = markup.fontfg(font, beautiful.widget_colors.kbd, layouts[cur_layout+1]:upper())
        --widget.markup = markup.fontfg(icon_font, beautiful.widget_colors.kbd, kbd_icon) .. " " ..
        --    markup.fontfg(font, beautiful.widget_colors.kbd, layouts[cur_layout+1]:upper())
    end

    awesome.connect_signal("xkb::map_changed",
        function(stdout, stderr, exitreason, exitcode)
            update_layout(kbd_widget, stdout, stderr, exitreason, exitcode)
    end)

    awesome.connect_signal("xkb::group_changed",
        function(stdout, stderr, exitreason, exitcode)
            update_layout(kbd_widget, stdout, stderr, exitreason, exitcode)
    end)

    update_layout(kbd_widget, stdout, stderr, exitreason, exitcode)

    local ret_widget = wibox.widget{
        {
            -- add margins
            wibox.widget.textbox(markup.fontfg(icon_font, beautiful.widget_colors.kbd, kbd_icon)),
            left = beautiful.icon_margin_left * 2,
            right = beautiful.icon_margin_right,
            color = "#FF000000",
            widget = wibox.container.margin
        },
        kbd_widget,
        layout = wibox.layout.fixed.horizontal,
        expand = "none"
    }

    ret_widget:connect_signal("button::press", function(_, _, _, button)
        spawn.easy_async(tog_layout_cmd, function(stdout, stderr, exitreason, exitcode)
            update_layout(kbd_widget, stdout, stderr, exitreason, exitcode)
        end)
    end)

    return ret_widget
end



return setmetatable({}, { __call = function(_, ...) return worker(...) end })

