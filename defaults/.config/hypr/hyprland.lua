local home = os.getenv("HOME")

package.path = home .. "/.config/hypr/configs/?.lua;" .. package.path

local status, module = pcall(require, "wallust-hyprland")

------------------------------------------
-- Variables
------------------------------------------
terminal = "kitty"
fileExplorer = "nautilus"


------------------------------------------
-- General settings
------------------------------------------
hl.config({
	general = {
		border_size = 3,
		gaps_in = 5,
		gaps_out = 20,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		}
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
	decoration = {
		rounding = 10,
		blur = { enabled = false },
	},
	ecosystem = {
		no_donation_nag = true
	}
})

------------------------------------------
-- Grouping settings
------------------------------------------
hl.config({
	group = {
		groupbar = {
			gradients = true,
			font_size = 10,
			height = 18,
			rounding = 10,
			gradient_rounding = 10
		}
	}
})
------------------------------------------
-- Rendering settings
------------------------------------------
hl.config({
	render = {
		direct_scanout = 2,
		cm_auto_hdr = 2,
	}
})
------------------------------------------
-- Input settings
------------------------------------------
hl.config({
	input = {
		kb_layout = "ch",
		kb_variant = "de",
		kb_options = "caps:swapescape",
		numlock_by_default = true,
		follow_mouse = 1,
		mouse_refocus = false,
		touchpad = {
			natural_scroll = true
		},
		accel_profile = "flat",
		sensitivity = 0.0
	},
	cursor = {
		no_hardware_cursors = true
	}
})
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace"
})

------------------------------------------
-- Group settings
------------------------------------------
hl.config({
	group = {
		groupbar = {
			font_size = 14,
			height = 24,
			gradients = true,
			col = {
				inactive = { colors = { "rgba(40, 40, 40, 0.7)", "rgba(80, 80, 80, 0.7)" }, angle = 90 },
				active = "rgba(142, 103, 25, 0.7)"
			}
		}
	}
})

------------------------------------------
-- Dwindle Layout settings
------------------------------------------
hl.config({
	dwindle = {
		preserve_split = true
	}
})

------------------------------------------
-- Master Layout settings
------------------------------------------
hl.config({
	master = {}
})

require("monitors")
require("envs")
require("execs")
require("key-bindings")
require("window-rules")
require("custom-config")
