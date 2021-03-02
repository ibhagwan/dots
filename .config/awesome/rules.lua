-- Standard awesome library
local awful = require("awful")
local beautiful = require("beautiful")


-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "Msgcompose",       -- Thunderbird's new email
          "Toplevel",         -- Thunderbird's TBsync addon
        },
        class = {
          "Bar",              -- lemonbar
          "Galculator",
          "gsimplecal",
          "TelegramDesktop",
          "Signal",
          "MEGAsync",
          "KeePassXC",
          "electrum",
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "bar",             -- lemonbar
          "OTPClient",
        },
        role = {
          "AlarmWindow",     -- Thunderbird's calendar.
          "ConfigManager",   -- Thunderbird's about:config.
          "pop-up",          -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "TelegramDesktop" }, properties = { tag = "1" } },
    { rule = { class = "Signal" },          properties = { tag = "1" } },
    { rule = { class = "firefox" },         properties = { tag = "4" } },
    { rule = { class = "Thunderbird" },     properties = { tag = "3" } },
    { rule = { class = "code-oss" },        properties = { tag = "5" } },
    { rule = { class = "Joplin" },          properties = { tag = "5" } },
    { rule = { class = "electrum" },        properties = { tag = "5" } },
    { rule = { class = "libreoffice-writer" },  properties = { tag = "5" } },
    { rule = { instance = "libreoffice" },  properties = { tag = "5" } },
    { rule = { name  = "Wasabi Wallet" },   properties = { tag = "6" } },
    { rule = { class = "cryptowatch_desktop" },   properties = { tag = "5" } },
}
-- }}}
