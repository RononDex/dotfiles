local mainMod = "SUPER" -- Sets "Windows" key as main modifier

----------------------------------
-- Launch applications bindings
----------------------------------
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileExplorer))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/selectBgImage.sh"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("wofi --show drun --allow-images --insensitive"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim ~/screens/$(date +"%s_grim.png")'))

----------------------------------
-- Manage windows bindings
----------------------------------
-- Move focus around
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + F", function()
	hl.dispatch(hl.dsp.window.fullscreen())
end)
hl.bind(mainMod .. " + SPACE", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
end)
hl.bind(mainMod .. " + SHIFT + Q", function()
	hl.dispatch(hl.dsp.window.close())
end)

----------------------------------
-- Workspace bindings
----------------------------------
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

----------------------------------
-- Hyprland bindings
----------------------------------
hl.bind(mainMod .. " + SHIFT + E", function()
	hl.dispatch(hl.dsp.exit())
end)
------------------------------------------
-- Laptop multimedia keys for volume and LCD brightness
------------------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("light -A 5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("light -U 5%"), { locked = true, repeating = true })
