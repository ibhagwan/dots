globals = {
  "awesome",
  "terminal",
  "terminal_alt",
  "terminal_mux",
  "editor",
  "editor_cmd",
  "modkey",
  "altkey",
  "client",
  "clientkeys",
  "clientbuttons",
  "screen",
  "mouse",
  "mousegrabber",
  "root",
  "mymainmenu",
}
std = "max"

unused = false
unused_args = false

ignore = { "412", "431" }

files["*.lua"].std = "+busted"
files['.luacheckrc'].global = false

files['themes/ibhagwan/*.lua'].ignore = { "111", "112", "113" }
files['themes/ibhagwan/widgets/*.lua'].ignore = { "111", "112", "113" }

include_files = {"helpers", "themes"}
exclude_files = {"lain"}
