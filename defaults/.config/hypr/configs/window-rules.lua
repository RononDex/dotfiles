---------------------------------
-- Opacity rules
---------------------------------
hl.window_rule({
	name = "kitty-transperency",
	match = {
		class = "kitty"
	},
	opacity = "0.96 0.83"
})
hl.window_rule({
	name = "signal-transperency",
	match = {
		class = "signal"
	},
	opacity = "0.95 0.8 1.0"
})
hl.window_rule({
	name = "nautilus-transperency",
	match = {
		class = "org.gnome.Nautilus"
	},
	opacity = "0.9 0.75 1.0"
})

---------------------------------
-- Smart gaps (no gaps if only window)
---------------------------------
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
	name        = "no-gaps-wtv1",
	match       = { float = false, workspace = "w[tv1]" },
	border_size = 0,
	rounding    = 0,
})
hl.window_rule({
	name        = "no-gaps-f1",
	match       = { float = false, workspace = "f[1]" },
	border_size = 0,
	rounding    = 0,
})
