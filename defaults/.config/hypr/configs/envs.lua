local gpg_tty = io.popen("tty"):read("*l")
hl.env("GPG_TTY", gpg_tty)

local ssh_auth_sock = io.popen("gpgconf --list-dirs agent-ssh-socket"):read("*l")
hl.env("SSH_AUTH_SOCK", ssh_auth_sock)
hl.env("TERM", terminal)
hl.env("MAKEFLAGS", "-j 8")

-------------------------------------
-- XWayland env variables
-------------------------------------
hl.env("XCURSOR_THEME", "BreezeX-RosePine-Linux")
hl.env("XCURSOR_SIZE", "24")

-------------------------------------
-- GTK env variables
-------------------------------------
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("GTK_THEME", "Colloid-Orange-Dark")

-------------------------------------
-- QT env variables
-------------------------------------
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-------------------------------------
-- XDG Specifications
-------------------------------------
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
