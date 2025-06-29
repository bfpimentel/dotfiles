spoon.SpoonInstall.repos.PaperWM = {
  url = "https://github.com/mogenson/PaperWM.spoon",
  desc = "PaperWM.spoon",
  branch = "release",
}

spoon.SpoonInstall:andUse("PaperWM", {
  repo = "PaperWM",
  -- config = { screen_margin = 16, window_gap = 2 },
  start = true,
  hotkeys = {},
})

local PaperWM = require("PaperWM")

PaperWM.window_gap = { top = 0, bottom = 8, left = 8, right = 8 }

PaperWM:bindHotkeys({
  -- switch to a new focused window in tiled grid
  focus_left = { { "alt" }, "h" },
  focus_down = { { "alt" }, "j" },
  focus_up = { { "alt" }, "k" },
  focus_right = { { "alt" }, "l" },

  -- switch windows by cycling forward/backward
  -- (forward = down or right, backward = up or left)
  focus_prev = { { "alt", "cmd" }, "k" },
  focus_next = { { "alt", "cmd" }, "j" },

  -- increase/decrease width
  increase_width = { { "alt", "cmd" }, "l" },
  decrease_width = { { "alt", "cmd" }, "h" },

  -- move windows around in tiled grid
  -- swap_left = { { "alt", "shift" }, "h" },
  swap_column_left = { { "alt", "shift" }, "h" },
  swap_down = { { "alt", "shift" }, "j" },
  swap_up = { { "alt", "shift" }, "k" },
  -- swap_right = { { "alt", "shift" }, "l" },
  swap_column_right = { { "alt", "shift" }, "l" },

  -- move focused window into / out of a column
  slurp_in = { { "alt", "cmd" }, "i" },
  barf_out = { { "alt", "cmd" }, "o" },

  -- move the focused window into / out of the tiling layer
  toggle_floating = { { "alt", "cmd" }, "f" },

  -- position and resize focused window
  center_window = { { "alt", "cmd" }, "c" },
  full_width = { { "alt", "cmd" }, "f" },
  cycle_width = { { "alt", "cmd" }, "r" },
  reverse_cycle_width = { { "ctrl", "alt", "cmd" }, "r" },
  cycle_height = { { "alt", "cmd", "shift" }, "r" },

  -- focus the first / second / etc window in the current space
  focus_window_1 = { { "cmd", "shift" }, "1" },
  focus_window_2 = { { "cmd", "shift" }, "2" },
  focus_window_3 = { { "cmd", "shift" }, "3" },
  focus_window_4 = { { "cmd", "shift" }, "4" },
  focus_window_5 = { { "cmd", "shift" }, "5" },
  focus_window_6 = { { "cmd", "shift" }, "6" },
  focus_window_7 = { { "cmd", "shift" }, "7" },
  focus_window_8 = { { "cmd", "shift" }, "8" },
  focus_window_9 = { { "cmd", "shift" }, "9" },

  -- switch to a new Mission Control space
  switch_space_l = { { "alt", "ctrl" }, "h" },
  switch_space_r = { { "alt", "ctrl" }, "l" },
  switch_space_1 = { { "alt", "ctrl" }, "1" },
  switch_space_2 = { { "alt", "ctrl" }, "2" },
  switch_space_3 = { { "alt", "ctrl" }, "3" },
  switch_space_4 = { { "alt", "ctrl" }, "4" },
  switch_space_5 = { { "alt", "ctrl" }, "5" },
  switch_space_6 = { { "alt", "ctrl" }, "6" },
  switch_space_7 = { { "alt", "ctrl" }, "7" },
  switch_space_8 = { { "alt", "ctrl" }, "8" },
  switch_space_9 = { { "alt", "ctrl" }, "9" },

  -- move focused window to a new space and tile
  move_window_l = { { "alt", "ctrl", "shift" }, "h" },
  move_window_r = { { "alt", "ctrl", "shift" }, "l" },
  move_window_1 = { { "alt", "ctrl", "shift" }, "1" },
  move_window_2 = { { "alt", "ctrl", "shift" }, "2" },
  move_window_3 = { { "alt", "ctrl", "shift" }, "3" },
  move_window_4 = { { "alt", "ctrl", "shift" }, "4" },
  move_window_5 = { { "alt", "ctrl", "shift" }, "5" },
  move_window_6 = { { "alt", "ctrl", "shift" }, "6" },
  move_window_7 = { { "alt", "ctrl", "shift" }, "7" },
  move_window_8 = { { "alt", "ctrl", "shift" }, "8" },
  move_window_9 = { { "alt", "ctrl", "shift" }, "9" },
})

PaperWM:start()
