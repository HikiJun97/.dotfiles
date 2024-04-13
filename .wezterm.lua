-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Palenight (Gogh)'
config.font = wezterm.font('Monaco Nerd Font Mono')
config.font_size = 13.0
config.leader = { key = 'a', mods = 'SHIFT' }
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


