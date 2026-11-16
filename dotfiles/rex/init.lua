-- Client
rex.bind("cmd+k", "client.palette.toggle")

rex.bind("ctrl+=", "client.font.increase")
rex.bind("ctrl+-", "client.font.decrease")
rex.bind("ctrl+0", "client.font.reset")

rex.bind("ctrl+b>s", "client.settings")
rex.bind("ctrl+b>r", "client.config.reload")
rex.bind("ctrl+b>b", "client.sidebar.toggle")

-- Session
rex.bind("ctrl+b>w", "session.switch")
rex.bind("ctrl+b>shift+n", "session.new")
rex.bind("ctrl+b>shift+w", "session.rename")
rex.bind("ctrl+b>shift+h", "session.previous")
rex.bind("ctrl+b>shift+l", "session.next")

-- Pane
rex.bind("ctrl+h", "pane.focus", { direction = "left" })
rex.bind("ctrl+j", "pane.focus", { direction = "down" })
rex.bind("ctrl+k", "pane.focus", { direction = "up" })
rex.bind("ctrl+l", "pane.focus", { direction = "right" })

rex.bind("ctrl+b>z", "pane.zoom")
rex.bind("ctrl+b>\\", "pane.split", { direction = "right" })
rex.bind("ctrl+b>/", "pane.split", { direction = "down" })
rex.bind("ctrl+b>x", "pane.close")

-- Tab
rex.bind("ctrl+b>c", "client.tab.new")
rex.bind("ctrl+b>,", "client.tab.rename")
rex.bind("ctrl+b>k", "client.tab.previous")
rex.bind("ctrl+b>j", "client.tab.next")
rex.bind("ctrl+b>shift+x", "client.tab.close")
for i = 1, 9 do
	rex.bind("ctrl+b>" .. i, "client.tab.goto", { index = i })
end

-- Resize
rex.mode("resize", { exclusive = true })
rex.bind("ctrl+b>shift+r", "client.mode.enter", { name = "resize" })
rex.bind("resize/escape", "client.mode.exit")
for _, direction in ipairs({ "left", "down", "up", "right" }) do
	rex.bind("resize/" .. direction, "pane.resize", { direction = direction })
end
