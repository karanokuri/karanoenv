local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.add_to_config_reload_watch_list(wezterm.home_dir..'/.karanoenv/dotfiles/.wezterm.lua')

local function file_exists(name)
  local f = io.open(name,"r")
  if f == nil then
    return false
  end
  io.close(f)
  return true
end

local function load_local_config(file)
  if file_exists(file) then
    return dofile(file)
  end
  return {}
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local cwd = tab.active_pane.current_working_dir:sub(9)
    return {
      { Text = ' ' .. cwd .. ' ' },
    }
  end
)

local config = {
  colors = {
    cursor_fg = 'black',
  },
  color_scheme = "Ayu Mirage",

  default_prog = { 'cmd.exe', '/c', 'call %USERPROFILE%\\.karanoenv\\setenv.bat && nyagos' },

  font = wezterm.font 'HackGen Console NF',
  font_dirs = { wezterm.home_dir..'/.karanoenv/apps/fonts' },
  font_size = 12.0,

  keys = {
    { key = 'n', mods = 'CTRL', action = act.SpawnCommandInNewTab {} },

    { key = 'h',          mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left'  },
    { key = 'l',          mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
    { key = 'k',          mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up'    },
    { key = 'j',          mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down'  },
    { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left'  },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up'    },
    { key = 'DownArrow',  mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down'  },
  },

  use_ime = true,
  text_background_opacity = 0.3,
  window_background_opacity = 0.85,
  window_decorations = 'RESIZE',
}

for k, v in pairs(load_local_config(wezterm.home_dir..'/.wezterm.lua')) do
  config[k] = v
end

return config
