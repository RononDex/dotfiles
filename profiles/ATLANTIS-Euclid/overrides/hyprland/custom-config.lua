--------------------------
-- Custom config
--------------------------
hl.config({
})
--------------------------
-- Custom envs
--------------------------
hl.env("PATH", os.getenv("PATH") .. ":" .. os.getenv("GOPATH") .. "/bin");

--------------------------
-- Custom Autostarts
--------------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("protonmail-bridge --no-window")
end)

--------------------------
-- Monitors config
--------------------------
hl.monitor({
	output = "eDP-1",
	mode = "1920x1200",
	position = "0x0",
	scale = 1.0,
})
