local Snacks = require("snacks")
local blink = require("blink-cmp")

local function command_line(icon, prompt)
  return Snacks.input(
    {
      icon = icon,
      prompt = prompt,
      title_pos = "center",
      b = { completion = true },
      keys = {
        -- i_ctrl_spc = { "<C-Space>", function() blink.show() end, mode = "i" },
        -- n_esc = { "<ESC>", { function() blink.cancel() end, "cancel" }, mode = "n", expr = true },
        -- i_esc = { "<ESC>", { function() blink.cancel() end, "stopinsert" }, mode = "i", expr = true },
        -- i_cr = { "<CR>", { function() blink.accept() end, "confirm" }, mode = { "i", "n" }, expr = true },
        -- i_tab = { "<TAB>", { function() blink.select_next() end, "cmp" }, mode = "i", expr = true },
        --
        -- i_ctrl_w = { "<C-w>", "<C-S-w>", mode = "i", expr = true },
        -- i_up = { "<C-p>", { "hist_up" }, mode = { "i", "n" } },
        -- i_down = { "<C-n>", { "hist_down" }, mode = { "i", "n" } },
        -- q = "cancel",
      }
    },
    function(cmd)
      if not cmd then return end

      local ok, err = pcall(vim.cmd, prompt .. cmd)
      if not ok then
        local idx = err:find(':E')
        if type(idx) ~= 'number' then
          return
        end
        local msg = err:sub(idx + 1):gsub('\t', '    ')
        Snacks.notify(msg, { level = "error" })
      end
    end
  )
end

vim.keymap.set("n", ":", function()
  local input = command_line("󰘳", ":")
  input.set_title(input, "Command")
end, { noremap = true })

vim.keymap.set("n", "/", function()
  local input = command_line("", "/")
  input.set_title(input, "Search")
end, { noremap = true })

return {
  "snacks.nvim",
  opts = {
    input = {
      icon = " ",
    },
    styles = {
      input = {
        border = "single",
      }
    },
  }
}
