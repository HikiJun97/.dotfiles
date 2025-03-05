-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action
-- This is where you actually apply your config choices

-- config.term = "xterm-256color"
-- config.term = "xterm"
config.term = "wezterm"
config.max_fps = 60
config.enable_kitty_graphics = false

-- Color Scheme Config
-- local COLOR_SCHEME = 'Kanagawa (Gogh)'
-- local COLOR_SCHEME = 'kanagawabones'
local COLOR_SCHEME = "Monokai Pro (Gogh)"
-- local COLOR_SCHEME = 'rose-pine-dawn'
-- local COLOR_SCHEME = 'Palenight (Gogh)'
-- local COLOR_SCHEME = 'One Dark (Gogh)'

-- Font Config
-- local FONT = "Monaco Nerd Font Mono"
-- local FONT = "UbuntuMono Nerd Font"
local FONT = "JetBrains Mono"
-- local FONT = "Menlo"
-- local FONT = "Monaco"
-- local FONT = "Iosevka"
config.color_scheme = COLOR_SCHEME

local font_config = {
	["Monaco Nerd Font Mono"] = {
		size = 12.0,
		line_height = 1.05,
		weight = "Medium",
	},
	["UbuntuMono Nerd Font"] = {
		size = 12.0,
		line_height = 1.05,
		weight = "Medium",
	},
	["JetBrains Mono"] = {
		size = 12.0,
		line_height = 1.00,
		weight = "Medium",
	},
	["Menlo"] = {
		size = 12.0,
		line_height = 1.05,
		weight = "Medium",
	},
	["Iosevka"] = {
		size = 14.0,
		line_height = 1.05,
		weight = "Medium",
	},
}

local selected_font = font_config[FONT] or {
	size = 12.0,
	line_height = 1.05,
}

config.font_size = selected_font.size
config.line_height = selected_font.line_height
config.freetype_load_target = "Light"
config.font = wezterm.font(FONT, { weight = selected_font.weight })
config.freetype_load_target = "Light"
config.leader = { key = "a", mods = "SHIFT" }
config.enable_wayland = true

local color_scheme = wezterm.color.get_builtin_schemes()[COLOR_SCHEME]

-- Tab Style
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true
-- config.tab_bar_style = {
-- 	new_tab = "🗝", -- 새 탭 버튼 아이콘
-- 	new_tab_hover = "➕", -- 마우스 오버시 새 탭 버튼
-- 	active_tab_left = "█", -- 활성 탭 왼쪽 구분자
-- 	active_tab_right = "█", -- 활성 탭 오른쪽 구분자
-- 	inactive_tab_left = "▒", -- 비활성 탭 왼쪽 구분자
-- 	inactive_tab_right = "▒", -- 비활성 탭 오른쪽 구분자
-- }

-- Window Frame
config.window_background_opacity = 100
config.window_frame = {
	active_titlebar_bg = color_scheme.background,
	-- font = wezterm.font({ family = FONT, weight = "Bold" }),
	font_size = 12.0,
}
config.window_decorations = "INTEGRATED_BUTTONS"
config.enable_scroll_bar = false
config.native_macos_fullscreen_mode = true
config.adjust_window_size_when_changing_font_size = false -- 폰트 크기 변경시 창 크기 조정
config.window_padding = {
	left = 0,
	right = 0,
	top = 10,
	bottom = 0,
}

function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local inactive_background = color_scheme.ansi[5]
	local edge_background = color_scheme.background
	local edge_foreground = color_scheme.foreground
	local background = color_scheme.background
	local foreground = color_scheme.foreground

	-- local title = tab_title(tab)
	local title = tab.active_pane.title
	title = wezterm.truncate_right(title, max_width)
	if tab.is_active then
		return {
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = foreground } },
			{ Foreground = { Color = background } },
			{ Text = title },
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	else
		return {
			-- { Background = { Color = edge_background } },
			-- { Foreground = { Color = edge_foreground } },
			-- { Text = SOLID_LEFT_ARROW },
			{ Background = { Color = inactive_background } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
			-- { Background = { Color = edge_background } },
			-- { Foreground = { Color = edge_foreground } },
			-- { Text = SOLID_RIGHT_ARROW },
		}
	end
end)

-- Key Bindings
config.keys = {
	-- This will create a new split and run the `top` program inside it
	{
		key = "%",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Left",
			command = { args = { "top" } },
			size = { Percent = 50 },
		}),
	},
	{
		key = '"',
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitVertical({
			args = { "top" },
		}),
	},
	{
		key = "%",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitHorizontal({
			args = { "top" },
		}),
	},
	{
		key = "H",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "J",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{ key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
	{
		key = "L",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "H",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "K",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "J",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},
}

return config
