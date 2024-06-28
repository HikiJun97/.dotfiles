-- Pull in the wezterm API
local wezterm = require 'wezterm' 

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- local COLOR_SCHEME = 'Kanagawa (Gogh)'
-- local COLOR_SCHEME = 'kanagawabones'
-- local COLOR_SCHEME = 'Monokai Pro (Gogh)'
local COLOR_SCHEME = 'rose-pine-dawn'
local FONT  = 'Monaco Nerd Font Mono'
config.color_scheme = COLOR_SCHEME
config.font = wezterm.font(FONT)
config.font_size = 13.0
config.leader = { key = 'a', mods = 'SHIFT' }

local color_scheme = wezterm.color.get_builtin_schemes()[COLOR_SCHEME]

-- Tab Style
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.show_tab_index_in_tab_bar = false
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
config.show_new_tab_button_in_tab_bar = false

-- Window Frame
config.window_background_opacity = 1
config.window_frame = {
	active_titlebar_bg = color_scheme.background,
}

function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, config, hover, max_width)
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

	end
)

-- Key Bindings
config.keys = {
  -- This will create a new split and run the `top` program inside it
  {
    key = '%',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitPane {
      direction = 'Left',
      command = { args = { 'top' } },
      size = { Percent = 50 },
    },
  },
  {
    key = '"',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitVertical {
      args = { 'top' },
    },
  },
  {
    key = '%',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitHorizontal {
      args = { 'top' },
    },
  },
  {
    key = 'H',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'J',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Down', 5 },
  },
  { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  {
    key = 'L',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'H',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'L',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'K',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'J',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Down',
  },
}

-- and finally, return the configuration to wezterm
return config


