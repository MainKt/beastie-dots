local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local awesome = awesome
local client = client
local root = root

require("awful.autofocus")

beautiful.init({
    useless_gap = beautiful.xresources.apply_dpi(3),
    border_width = beautiful.xresources.apply_dpi(2),
    border_normal = "#2c323a",
    border_focus = "#e95798",
    scratch_focus = "#5e81ac",
})

awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "scratchpad" }, s, awful.layout.suit.tile)
end)

local term_cmd = "kitty"
local term_tmux_cmd = "kitty tmux"
local btop_cmd = "kitty --title=sysmon btop"
local scratchpad_cmd = "kitty --title=scratchpad sh -c 'SCRATCHPAD=y exec bash'"

local globalkeys = gears.table.join(
    awful.key({ "Mod4" }, "0", function()
        awful.tag.viewmore(awful.screen.focused().tags, awful.screen.focused())
    end),
    --
    awful.key({ "Mod4", "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end),
    awful.key({ "Mod4", "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end),
    --
    awful.key({ "Mod4" }, "l", function() awful.tag.incmwfact(0.05) end),
    awful.key({ "Mod4" }, "h", function() awful.tag.incmwfact(-0.05) end),
    --
    awful.key({ "Mod4", "Control" }, "r", awesome.restart),
    awful.key({ "Mod4", "Mod1" }, "q", awesome.quit),
    --
    awful.key({ "Mod4", "Shift" }, "Return", function() awful.spawn(term_cmd) end),
    awful.key({ "Mod4", "Mod1" }, "Return", function() awful.spawn(term_tmux_cmd) end),
    awful.key({ "Mod4" }, "Escape", function() awful.spawn("warpd --normal") end),
    awful.key({ "Mod4" }, "q", function() awful.spawn("warpd --normal") end),
    awful.key({ "Mod4" }, ";", function() awful.spawn("warpd --history") end),
    awful.key({ "Mod4" }, "f", function() awful.spawn("warpd --hint") end),
    awful.key({ "Mod4", "Shift" }, "f", function() awful.spawn("warpd --hint2") end),
    awful.key({ "Mod4" }, "w", function() awful.spawn("firefox") end),
    awful.key({ "Mod4", "Mod1" }, "Escape", function() awful.spawn("slock") end),
    --
    awful.key({ "Mod4" }, "j", function() awful.client.focus.byidx(1) end),
    awful.key({ "Mod4" }, "k", function() awful.client.focus.byidx(-1) end),
    --
    awful.key({ "Mod4", "Shift" }, "j", function() awful.client.swap.byidx(1) end),
    awful.key({ "Mod4", "Shift" }, "k", function() awful.client.swap.byidx(-1) end),
    --
    awful.key({ "Mod4" }, "[", awful.tag.viewprev),
    awful.key({ "Mod4" }, "]", awful.tag.viewnext),
    --
    awful.key({ "Mod4" }, "Tab", awful.tag.history.restore),
    --
    awful.key({ "Mod1" }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
    --
    awful.key({}, "Print", function() awful.spawn(".local/bin/screenclip -f") end),
    awful.key({ "Mod1" }, "Print", function() awful.spawn(".local/bin/screenclip") end),
    --
    awful.key({ "Mod4" }, "Down", function()
        awful.spawn("xbacklight -5")
        awful.spawn("backlight - 5")
    end),
    awful.key({ "Mod4" }, "Up", function()
      awful.spawn("xbacklight +5")
      awful.spawn("backlight + 5")
    end),
    --
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("mixer vol=-10%") end),
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("mixer vol=+10%") end),
    awful.key({}, "XF86AudioMute", function() awful.spawn("mixer vol.mute=toggle") end),
    --
    awful.key({ "Mod4" }, "s", function() awful.spawn(".local/bin/notify-status") end),
    --
    awful.key({ "Mod4" }, "=", function()
        local c = awful.client.restore()
        if not c then return end
        c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end)
)

for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,
        awful.key({ "Mod4" }, "#" .. i + 9, function()
            local tag = awful.screen.focused().tags[i]
            if tag then tag:view_only() end
        end),
        --
        awful.key({ "Mod4", "Mod1" }, "#" .. i + 9, function()
            local tag = awful.screen.focused().tags[i]
            if tag then awful.tag.viewtoggle(tag) end
        end),
        --
        awful.key({ "Mod4", "Shift" }, "#" .. i + 9, function()
            if not client.focus then return end
            local tag = client.focus.screen.tags[i]
            if tag then client.focus:move_to_tag(tag) end
        end),
        --
        awful.key({ "Mod4", "Control" }, "#" .. i + 9, function()
            if not client.focus then return end
            local tag = client.focus.screen.tags[i]
            if tag then client.focus:toggle_tag(tag) end
        end),
        awful.key({ "Mod4" }, "p", function()
            local c = awful.client.iterate(function(c)
                return awful.rules.match(c, { name = "scratchpad" })
            end)()

            c.hidden = not c.hidden
            client.focus = c
        end)
    )
end

root.keys(globalkeys)

local clientkeys = gears.table.join(
    awful.key({ "Mod4", "Control" }, "h", function(c) c:relative_move(0, 0, -40, 0) end),
    awful.key({ "Mod4", "Control" }, "j", function(c) c:relative_move(0, 0, 0, 40) end),
    awful.key({ "Mod4", "Control" }, "k", function(c) c:relative_move(0, 0, 0, -40) end),
    awful.key({ "Mod4", "Control" }, "l", function(c) c:relative_move(0, 0, 40, 0) end),
    --
    awful.key({ "Mod4", "Mod1" }, "h", function(c) c:relative_move(-40, 0, 0, 0) end),
    awful.key({ "Mod4", "Mod1" }, "j", function(c) c:relative_move(0, 40, 0, 0) end),
    awful.key({ "Mod4", "Mod1" }, "k", function(c) c:relative_move(0, -40, 0, 0) end),
    awful.key({ "Mod4", "Mod1" }, "l", function(c) c:relative_move(40, 0, 0, 0) end),
    --
    awful.key({ "Mod4" }, "c", function(c) awful.placement.centered(c) end),
    --
    awful.key({ "Mod4", "Shift" }, "q", function(c) c:kill() end),
    --
    awful.key({ "Mod4" }, "space", awful.client.floating.toggle),
    --
    awful.key({ "Mod4" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
    --
    awful.key({ "Mod4" }, "t", function(c) c.ontop = not c.ontop end),
    --
    awful.key({ "Mod4", "Shift" }, "[", function(c)
        awful.tag.viewprev()
        local t = awful.screen.focused().selected_tag
        c:move_to_tag(t)
    end),
    awful.key({ "Mod4", "Shift" }, "]", function(c)
        awful.tag.viewnext()
        local t = awful.screen.focused().selected_tag
        c:move_to_tag(t)
    end),
    --
    awful.key({ "Mod4", "Control" }, "[", function(c)
        awful.tag.viewprev()
        local t = awful.screen.focused().selected_tag
        c:toggle_tag(t)
        awful.tag.viewnext()
    end),
    awful.key({ "Mod4", "Control" }, "]", function(c)
        awful.tag.viewnext()
        local t = awful.screen.focused().selected_tag
        c:toggle_tag(t)
        awful.tag.viewprev()
    end),
    --
    awful.key({ "Mod4" }, "-", function(c) c.minimized = true end)
)

local clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ "Mod4" }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ "Mod4" }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    },

    { rule = { name = "sysmon" },  properties = { tag = "9" } },

    { rule = { class = "firefox" }, properties = { tag = "8" } },

    {
        rule = { name  = "scratchpad" },
        properties = {
            tag = "scratchpad",
            floating = true,
            sticky = true,
            hidden = true,
            ontop = true,
            width = beautiful.xresources.apply_dpi(700),
            height = beautiful.xresources.apply_dpi(400),
            placement = function(c)
                awful.placement.centered(c, { honor_workarea = true })
            end,
        },
    },
}

client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c)
    c.border_color = c.name == "scratchpad" and
        beautiful.scratch_focus or beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    c.hidden = c.name == "scratchpad"
end)

for _, cmd in ipairs({
    "picom",
    "sxhkd",
    "dunst",
    "unclutter",
    "gromit-mpx",
    btop_cmd,
    scratchpad_cmd,
    "firefox",
}) do
    awful.spawn.with_shell("pgrep -f '" .. cmd:gsub("'", "") .. "' ||" .. cmd)
end

for _, cmd in ipairs({
    "wmname LG3D",
    "feh --bg-scale --randomize ~/pics/wallpapers/",
    "xinput disable $(xinput list | awk '/TouchPad/ {print$6}' | cut -d= -f2)",
    "xbacklight -set 20",
    "xrandr --output eDP --brightness 0.3",
    "backlight 20",
    "setxkbmap -option 'caps:ctrl_modifier'",
    "xcape -e 'Caps_Lock=Escape'",
}) do awful.spawn.with_shell(cmd) end
