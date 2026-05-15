--------------------------
-- Custom envs
--------------------------
hl.env("MAKEFLAGS", "-j 16");
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
	output = "DP-1",
	mode = "3840x2160@144",
	position = "0x0",
	scale = 1.5,
	bitdepth = 10,
	sdrbrightness = 1.2,
	sdrsaturation = 1.1,
	supports_wide_color = 1,
	supports_hdr = 1,
	cm = "hdredid",
	sdr_min_luminance = 0.05,
	sdr_max_luminance = 220,
	max_luminance = 1300,
	min_luminance = 0
})
hl.monitor({
	output = "DP-2",
	mode = "2560x1440@144",
	position = "2560x0",
	scale = "1.0",
})
