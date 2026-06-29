Pack.later(function()
  local function nav(wincmd, dir)
    local prev = vim.api.nvim_get_current_win()
    vim.cmd("wincmd " .. wincmd)
    if vim.api.nvim_get_current_win() ~= prev then
      return -- moved within Neovim
    end
    -- At a split edge: cross into the surrounding multiplexer.
    if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
      local herdr = vim.env.HERDR_BIN_PATH
      if herdr == nil or herdr == "" then herdr = "herdr" end
      vim.fn.system({ herdr, "pane", "focus", "--direction", dir, "--current" })
    elseif vim.env.TMUX and vim.env.TMUX ~= "" then
      local tmux = { left = "Left", down = "Down", up = "Up", right = "Right" }
      pcall(vim.cmd, "TmuxNavigate" .. tmux[dir])
    end
  end

  local function map(lhs, wincmd, dir, desc)
    Util.map_keys({
      { lhs, function() nav(wincmd, dir) end, { silent = true, noremap = true, desc = desc } },
    })
  end

  map("<C-h>", "h", "left", "Navigate left (vim/herdr)")
  map("<C-j>", "j", "down", "Navigate down (vim/herdr)")
  map("<C-k>", "k", "up", "Navigate up (vim/herdr)")
  map("<C-l>", "l", "right", "Navigate right (vim/herdr)")
end)
