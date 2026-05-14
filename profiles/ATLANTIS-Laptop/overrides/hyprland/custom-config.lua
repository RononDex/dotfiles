--------------------------
-- Custom envs
--------------------------
hl.env("PATH", "$PATH:$GOPATH/bin");

--------------------------
-- Custom Autostarts
--------------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("iio-hyprland")
	hl.exec_cmd("wvkbd-mobintl -L 250 --hidden")
	hl.exec_cmd("protonmail-bridge --no-window")
end)

--------------------------
-- Monitors config
--------------------------
hl.monitor({
	output = "HDMI-A-1",
	mode = "preferred",
	position = "auto",
	scale = "auto",
	mirror = "eDP-1"
})
hl.monitor({
	output = "eDP-1",
	mode = "1920x1200@60",
	position = "0x0",
	scale = "1.0",
	mirror = "eDP-1"
})
